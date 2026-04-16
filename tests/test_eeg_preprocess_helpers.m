function tests = test_eeg_preprocess_helpers
project_root = fileparts(fileparts(mfilename('fullpath')));
src_dir = fullfile(project_root, 'src');
if exist(src_dir, 'dir')
    addpath(src_dir);
end
tests = functiontests(localfunctions);
end

function testDefaultConfigContainsExpectedFixedValues(testCase)
cfg = default_preprocess_config();

verifyEqual(testCase, cfg.output_root, "F:\CJZFile\EEG_scriptProcess");
verifyEqual(testCase, cfg.lookup_file, "F:\CJZFile\EEG_M1\standard_1005.ced");
verifyEqual(testCase, cfg.target_sample_rate, 250);
verifyEqual(testCase, cfg.highpass_hz, 0.5);
verifyEqual(testCase, cfg.lowpass_hz, 45);
verifyEqual(testCase, cfg.notch_band_hz, [49 51]);
verifyEqual(testCase, cfg.remove_channels, ["HEO" "VEO" "EKG" "EMG"]);
verifyEqual(testCase, cfg.reference_labels, ["M1" "M2"]);
end

function testLoadConfigCreatesMissingFileWithDefaults(testCase)
tmpDir = tempname;
mkdir(tmpDir);
cleanup = onCleanup(@() rmdir(tmpDir, 's')); %#ok<NASGU>

cfgPath = fullfile(tmpDir, 'preprocess_config.json');
loaded = load_preprocess_config(cfgPath);

verifyTrue(testCase, isfile(cfgPath));
verifyEqual(testCase, loaded.target_sample_rate, 250);
verifyEqual(testCase, loaded.notch_band_hz, [49 51]);
end

function testSaveAndLoadConfigRoundTripsEditableParameters(testCase)
tmpDir = tempname;
mkdir(tmpDir);
cleanup = onCleanup(@() rmdir(tmpDir, 's')); %#ok<NASGU>

cfgPath = fullfile(tmpDir, 'preprocess_config.json');
cfg = default_preprocess_config();
cfg.target_sample_rate = 200;
cfg.highpass_hz = 1.0;
cfg.lowpass_hz = 40;

save_preprocess_config(cfg, cfgPath);
loaded = load_preprocess_config(cfgPath);

verifyEqual(testCase, loaded.target_sample_rate, 200);
verifyEqual(testCase, loaded.highpass_hz, 1.0);
verifyEqual(testCase, loaded.lowpass_hz, 40);
verifyEqual(testCase, loaded.notch_band_hz, [49 51]);
verifyEqual(testCase, loaded.reference_labels, ["M1" "M2"]);
end

function testBuildOutputPathsMirrorsSourceHierarchy(testCase)
sourceRoot = "F:\source\Patient_tACS_M1_EEG";
inputFile = "F:\source\Patient_tACS_M1_EEG\baseline\subject_011\sqm1.cnt";
outputRoot = "F:\output";

paths = build_output_paths(sourceRoot, inputFile, outputRoot);

expectedDir = string(fullfile(char(outputRoot), 'Patient_tACS_M1_EEG', 'baseline', 'subject_011'));
verifyEqual(testCase, paths.output_dir, expectedDir);
verifyEqual(testCase, paths.set_path, string(fullfile(char(expectedDir), 'sqm1.set')));
verifyEqual(testCase, paths.fdt_path, string(fullfile(char(expectedDir), 'sqm1.fdt')));
end

function testBuildOutputPathsKeepsOnlySelectedFolderHierarchy(testCase)
sourceRoot = "F:\source\Patient_tACS_M1_EEG\baseline\sub05殷文海";
inputFile = "F:\source\Patient_tACS_M1_EEG\baseline\sub05殷文海\session_a\trial01.cnt";
outputRoot = "F:\output_gui";

paths = build_output_paths(sourceRoot, inputFile, outputRoot);

expectedDir = string(fullfile(char(outputRoot), 'sub05殷文海', 'session_a'));
verifyEqual(testCase, paths.output_dir, expectedDir);
verifyEqual(testCase, paths.set_path, string(fullfile(char(expectedDir), 'trial01.set')));
verifyEqual(testCase, paths.fdt_path, string(fullfile(char(expectedDir), 'trial01.fdt')));
end

function testCollectCntFilesRecursesAndSorts(testCase)
tmpDir = tempname;
mkdir(tmpDir);
cleanup = onCleanup(@() rmdir(tmpDir, 's')); %#ok<NASGU>

mkdir(fullfile(tmpDir, 'A'));
mkdir(fullfile(tmpDir, 'B', 'nested'));
fclose(fopen(fullfile(tmpDir, 'A', 'a_file.cnt'), 'w'));
fclose(fopen(fullfile(tmpDir, 'B', 'nested', 'b_file.cnt'), 'w'));
fclose(fopen(fullfile(tmpDir, 'B', 'nested', 'ignore.txt'), 'w'));

files = collect_cnt_files(tmpDir);
expected = string(sort({
    fullfile(tmpDir, 'A', 'a_file.cnt')
    fullfile(tmpDir, 'B', 'nested', 'b_file.cnt')
}));

verifyEqual(testCase, files, expected);
end

function testCountCntFilesReturnsZeroForEmptyFolder(testCase)
tmpDir = tempname;
mkdir(tmpDir);
cleanup = onCleanup(@() rmdir(tmpDir, 's')); %#ok<NASGU>

count = count_cnt_files(tmpDir);

verifyEqual(testCase, count, 0);
end

function testCountCntFilesCountsNestedCntFiles(testCase)
tmpDir = tempname;
mkdir(tmpDir);
cleanup = onCleanup(@() rmdir(tmpDir, 's')); %#ok<NASGU>

mkdir(fullfile(tmpDir, 'nested'));
fclose(fopen(fullfile(tmpDir, 'a.cnt'), 'w'));
fclose(fopen(fullfile(tmpDir, 'nested', 'b.cnt'), 'w'));
fclose(fopen(fullfile(tmpDir, 'nested', 'ignore.txt'), 'w'));

count = count_cnt_files(tmpDir);

verifyEqual(testCase, count, 2);
end

function testFindReferenceChannelIndicesReturnsM1M2Indices(testCase)
labels = ["Fp1" "M1" "Cz" "M2"];

indices = find_reference_channel_indices(labels, ["M1" "M2"]);

verifyEqual(testCase, indices, [2 4]);
end

function testFindReferenceChannelIndicesErrorsWhenLabelsMissing(testCase)
verifyError(testCase, ...
    @() find_reference_channel_indices(["Fp1" "Cz"], ["M1" "M2"]), ...
    'EEGPreprocess:MissingReferenceChannel');
end

function testDefaultSmokeTestSourceRootUsesPatientDirectory(testCase)
sourceRoot = default_smoke_test_source_root();

verifyEqual(testCase, sourceRoot, "F:\CJZFile\EEG_M1\Patient_tACS_M1_EEG");
end

function testValidateLookupFilePathRejectsEmptyPath(testCase)
verifyError(testCase, ...
    @() validate_lookup_file_path(""), ...
    'EEGPreprocess:MissingLookupFile');
end

function testValidateLookupFilePathRejectsMissingFile(testCase)
verifyError(testCase, ...
    @() validate_lookup_file_path("F:\missing_lookup_file.ced"), ...
    'EEGPreprocess:LookupFileNotFound');
end

function testValidateLookupFilePathRejectsWrongExtension(testCase)
tmpDir = tempname;
mkdir(tmpDir);
cleanup = onCleanup(@() rmdir(tmpDir, 's')); %#ok<NASGU>

wrongPath = fullfile(tmpDir, 'lookup.txt');
fclose(fopen(wrongPath, 'w'));

verifyError(testCase, ...
    @() validate_lookup_file_path(string(wrongPath)), ...
    'EEGPreprocess:InvalidLookupFile');
end

function testValidateLookupFilePathAcceptsCedFile(testCase)
tmpDir = tempname;
mkdir(tmpDir);
cleanup = onCleanup(@() rmdir(tmpDir, 's')); %#ok<NASGU>

lookupPath = fullfile(tmpDir, 'lookup.ced');
fclose(fopen(lookupPath, 'w'));

validatedPath = validate_lookup_file_path(string(lookupPath));

verifyEqual(testCase, validatedPath, string(lookupPath));
end

function testSummarizeSmokeTestResultsCountsStatusesAndOutputs(testCase)
results = repmat(struct( ...
    'input_file', "", ...
    'output_dir', "", ...
    'set_path', "", ...
    'fdt_path', "", ...
    'status', "", ...
    'message', "", ...
    'channel_count', NaN, ...
    'sample_rate', NaN, ...
    'elapsed_seconds', NaN), 2, 1);

results(1).status = "processed";
results(1).set_path = "existing_1.set";
results(1).fdt_path = "existing_1.fdt";

results(2).status = "failed";
results(2).message = "mock failure";

summary = summarize_smoke_test_results(results, [true false], "F:\mock\source");

verifyEqual(testCase, summary.source_root, "F:\mock\source");
verifyEqual(testCase, summary.total_files, 2);
verifyEqual(testCase, summary.processed_count, 1);
verifyEqual(testCase, summary.failed_count, 1);
verifyEqual(testCase, summary.skipped_existing_count, 0);
verifyFalse(testCase, summary.all_outputs_exist);
end

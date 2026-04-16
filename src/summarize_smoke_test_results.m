function summary = summarize_smoke_test_results(results, output_exists, source_root)
%SUMMARIZE_SMOKE_TEST_RESULTS Summarize smoke-test batch results.

statuses = string({results.status});
messages = string({results.message});

summary = struct();
summary.source_root = string(source_root);
summary.total_files = numel(results);
summary.processed_count = sum(statuses == "processed");
summary.failed_count = sum(statuses == "failed");
summary.skipped_existing_count = sum(statuses == "skipped_existing");
summary.all_outputs_exist = all(output_exists);
summary.any_failures = any(statuses == "failed");
summary.failure_messages = messages(statuses == "failed");
end

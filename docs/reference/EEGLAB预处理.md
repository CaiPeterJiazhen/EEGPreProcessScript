## 1.导入CNT文件
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751540647733-699df2df-f9ea-4429-ba45-f2f2903c9dfa.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751540808280-38ff6a5a-65e7-4c68-82ee-73d6b9f1c8f5.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751540889185-eaa33759-3f6d-4f40-8409-74a9f3f7c6ad.png)

此处改名为代存状态



## 2.电极定位
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751541058318-fdc74d01-24d7-45fc-9cb9-42a13b6cc0d3.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751541232789-9bfaf146-5bf8-4ea3-b137-272856544498.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751541280905-4f88910b-c6d6-49ef-adc5-4efb6f3472be.png)



二维的电极定位图应该是这样的（如果需要CB1和CB2）

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751541290979-5e65ef54-3828-4046-a0cc-7634ce7d2fa7.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751541476378-3c4799e4-c255-47b7-9c81-6db9e1912c5b.png)



点OK

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751545562521-2f2caa89-8f3a-43d3-ada6-c6f3222a87eb.png)

这里会变为YES



## 3.移除空电极
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751541526837-54e4b8c5-a476-4579-8fc0-b73496ea3bae.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751541654286-d997cea7-b6a7-4278-9be6-deb370f611be.png)

这两个都点OK

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751541668549-82c03566-16c1-479d-8acf-7599fd36ca4d.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751541690980-c6ac335e-e4a1-40b2-a3ec-77c8ff17bd3a.png)

去出完空电极，通道数会改变

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751541748970-0737358b-3cde-40dd-b9e5-c4cd4306a35b.png)



## 4.降采样率
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751541826857-62bb34a7-39f1-4352-92c2-66afe6a87b48.png)

弹出的两个框都点OK

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751541879558-9b382faa-f590-4e83-8118-db5dc50f836e.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751541903416-0dc11c34-51ce-4401-bb0c-06a252b00b2c.png)

采样率发生了改变

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751541956726-c68b4d0e-6fef-4111-a3ee-9a4b9b7db94b.png)



## 5.滤波
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751542016175-a7817285-ca99-4d20-be6c-91d4569f536d.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751542085763-65549d1f-593d-4dd4-a49b-3118be612343.png)

此处先设的低通滤波，设置完点击OK

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751542157058-037d685c-47b2-455f-891f-ee01113af4e0.png)

高通滤波同样的操作

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751542187139-ca712817-3e0f-49eb-b456-d555a055aa36.png)

还需要去除工频干扰

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751542484475-fee9a018-fe9a-4785-a5be-550f817202f4.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751542519996-56d06ac2-7eca-4816-9ba8-549c9f6863bf.png)

## 6.重参考
重参考可以设置M1 M2 乳突位置的重参考，还可以设置全局平均参考

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751542655668-8883330a-b77a-4404-9875-b9cd3529b1b5.png)

### 全局平均参考
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751542794427-02d4b2ec-2e91-4c3c-a98c-1e6032404ea7.png)

如果用全局参考，要删除M1和M2

### M1和M2参考
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751542887052-66cde3ff-df1a-4ca9-af65-23a256dd9414.png)

一直点OK

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751542988561-707024d8-9354-4613-b1aa-d7a208138ce5.png)

参考电极变成M1、M2了

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751543016427-8e7db744-0623-4a1b-bdd0-c47fcc752206.png)



## 7.去除坏段
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751544335064-00c9ba81-3024-426a-a607-ee2fe5d9c28e.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751544428096-b434f497-c902-40c1-a191-965bfee25eb3.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751544603028-4e23b43a-0fa6-40ed-8a94-79d1fd956f20.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751544626440-839aa864-9a5a-4b8b-8c9b-693ec046da5f.png)

点击OK

## 8.跑ICA
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751543111266-e4a4278a-2676-4c31-967f-9ae5114b3ab1.png)

没有差值坏导的话，直接点OK（如果有差值坏导，看后面有教程）

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751543197498-09e6a088-6d91-420e-85f8-6fcd4c097366.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751543265325-fa65e2ea-057f-438f-a43e-4d006e48a72c.png)

不要点interupt，这个是终止按键，ICA时间有点长

 ICA这一栏会变为YES

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751543467503-31a0f7a0-35cf-4c70-b9d7-919937f6955a.png)

## 9.去伪迹（此步每个文件都不太一样哦）
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751543580868-0ab9318f-fba5-4102-877a-a2bb25972faf.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751543597374-7d8fff19-e034-47ee-b93b-59a4ba89f937.png)

点OK

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751543633804-55579883-7953-400e-960d-c2a2fa10f0ba.png)

接着点OK

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751543652049-56e5c010-563a-4221-b91c-a6fa49f297af.png)

再来点OK！

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751543911738-b1593189-9c3e-4065-8a50-c50360bc3813.png)

接下来是去伪迹

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751543955349-15dcc147-2be2-4069-99cf-3d633cd4aae4.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751544154826-27607ad3-4d1a-496b-a3d5-b9312e188adc.png)

点接收

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751544173409-e2caf702-f72a-48d8-be9a-bcd517cf7e9d.png)



如果需要同时去除多个通道，数字之间加空格就行

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751544280123-0202b230-18b8-480b-9c0b-39e678ef0484.png)



<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/43316864/1776228890982-569b855f-4031-4d60-8c3b-b6ae38f24c2a.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/43316864/1776228914253-71774f04-1527-42a3-baf6-0473071955cb.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/43316864/1776229748646-38f1f069-8a81-4bd3-b633-6eb18b538907.png)<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/43316864/1776229841157-7182cb19-3b7c-4628-a53d-755322835c98.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/43316864/1776229855952-f169697d-655f-4191-87d5-e9f1327fb338.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/43316864/1776229873693-1a1ab7a2-18d6-4d93-ac0c-f3d52e16e74c.png)

## 10.差值坏导


（看病历本和PLOT图，有就行，没有不管）

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751544693812-af122464-61fd-425c-adec-abafad5f8a5a.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751544725092-ca0779a2-b1cd-46e8-b01d-09c50af14e55.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751544740845-6bc6466e-2741-42f9-8615-a474f5d89588.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751544778042-1432b430-fa8c-4fc6-88f8-821b3f046126.png)

差值坏导去除后，再跑一遍ICA

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751544903248-c16d87ef-8ceb-4991-ad10-312fec46792e.png)

此处跑ICA时，需要更改箭头指向处，1后面需要加<u> </u>**<u>,'pca',通道数-差值坏导的数</u>**

然后点OK

**每次跑完ICA，还需要再去除伪迹，再去伪迹的步骤和之前一样**

****

## 11.保存
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751545369893-04ac3453-53f3-49d5-a815-3c7d9ddfeec9.png)

处理完的文件，如图中所示，需要另存为新的文件，原始文件并没有改变

若要改变原始文件，需要点击save current dataset(s)



## 12.代码预处理
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751546114683-4546674c-3c56-46a2-aaed-4145553932f9.png)

代码预处理时，记得最后要运行这个语句

```matlab
eeglab redraw; %更新EEGLAB窗口
```

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2025/png/43316864/1751546273497-055ca263-82f6-4fdf-881d-fe87320aa397.png)

点这个可以保存EEGLAB操作的对应代码




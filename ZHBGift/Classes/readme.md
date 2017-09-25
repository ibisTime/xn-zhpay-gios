
## 代码问题
和商家端共用代码

### 不同点
1. 首页不同
2. 账单查询不同
3. 账单查询不停 ->ZHBillTypeChooseVC.m ->ZHBillVC,所以AccountMgt选择性的加入Pods

4. 登录页不同，选择性的加入 ZHUserLoginVC,ZHUserRegistVC 不需要加入
5. 实名认证不同，通过宏定义可以解决，优先级降低
6. 添加商品不同
7. 添加规格不同

8. appConfig不同

4.5.6.7写兼容代码 ？？？？

### plan
 1.去掉pch文件
 2.独立代码抽离



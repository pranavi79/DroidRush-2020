import 'dart:collection';
class Person{
  String name;
  String username;
  String pass;
  String email;
  LinkedHashMap moneyIOweList = LinkedHashMap<double, String>();//money I owe
  LinkedHashMap moneyOwedList = LinkedHashMap<double, String>();//money I lent
  //bool paid;
  void getName(String name){
    this.name=name;
  }
  String setName(){
    return name;
  }
  void getMoneyIOwe(String group,double amount){
    moneyIOweList.putIfAbsent(group, ()=>amount);
  }
  void getMoneyOwed(String group,double amount){
    moneyOwedList.putIfAbsent(group, ()=>amount);
  }
  void remove(String group){
    moneyIOweList.remove(group);
  }
  void remove2(String group){
    moneyOwedList.remove(group);
  }
  //Transactions editTransactions(){}
}
class Group{
  String group;
  String admin;
  double total;
  LinkedHashMap grouplist= LinkedHashMap<double,String>();
  //int noOfMembs; will get total from firebase
  void setGroup(String group,double total,String username){ //user will not have to send his username,automatically from firebase
    this.group=group;
    this.total=total;
    this.admin=username;
    Person u = Person() ;
    u.getMoneyOwed(group, total);
  }
  void addMembers(String user,double amount){
    grouplist.putIfAbsent(user,()=>amount);
    Person u = Person() ;
    u.getMoneyIOwe(group, amount);
  }
  void deleteMembers(String user,double amount){
    grouplist.remove(user);
    Person u = Person() ;
    u.remove(this.group);
  }
  // void editMembers(String user,double amount){
  //   //edit individual amount
  //   Person u =new User(user);
  //   u.edit(this.group,amount);
  // }
  void editGroup(){
    //change amount
  }
  void deleteGroup(){
    //if grouplist=empty,automatically delete
        if(grouplist.isEmpty){
        Person u = Person() ;
        u.remove2(this.group);
        }
  }
}
abstract class Transactions{
  double amount;
  String title;
  String comment;
}
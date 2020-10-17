import 'dart:collection';
//package:flutter/material.dart';

// void main(List<String> args) {
//   runApp(MyApp());
  
// }

// class MyApp extends StatelessWidget {

// }
class User{
  String name;
  String username;
  //String pass;
  LinkedHashMap MoneyIOweList = LinkedHashMap<double, String>();//money I owe
  LinkedHashMap MoneyOwedList = LinkedHashMap<double, String>();//money I lent
  //bool paid;
  void getName(String name){
    this.name=name;
  }
  String setName(){
    return name;
  }
  void getMoneyIOwe(String group,double amount){
    MoneyIOweList.putIfAbsent(group, ()=>amount);
  }
  void getMoneyOwed(String group,double amount){
    MoneyOwedList.putIfAbsent(group, ()=>amount);
  }
  void remove(String group){
    MoneyIOweList.remove(group);
  }
  void remove2(String group){
    MoneyOwedList.remove(group);
  }
  //Transactions editTransactions(){}
  User(String username);
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
    User u = User(username);
    this.admin=username;
    u.getMoneyOwed(group, total);
  }
  void addMembers(String user,double amount){
    grouplist.putIfAbsent(user,()=>amount);
    User u = User(user);
    u.getMoneyIOwe(group, amount);
  }
  void deleteMembers(String user,double amount){
    grouplist.remove(user);
    User u = User(user);
    u.remove(this.group);
  }
  // void editMembers(String user,double amount){
  //   //edit individual amount
  //   User u =new User(user);
  //   u.edit(this.group,amount);
  // }
  void editGroup(){
    //change amount
  }
  void deleteGroup(){
    //if grouplist=empty,automatically delete
        if(grouplist.isEmpty){
        User u = User(this.admin);
        u.remove2(this.group);
        }
  }
}
abstract class Transactions{
  double amount;
  String title;
  String comment;
}
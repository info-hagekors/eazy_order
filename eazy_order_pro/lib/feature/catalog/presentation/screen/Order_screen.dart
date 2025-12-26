import 'package:core/config/app_colors.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget{
  const OrderScreen ({super.key});

  static const String routeName = '/orderscreen';

  @override
  State<OrderScreen> createState()=> _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text("Order screen",style: TextStyle(color: AppColors.black),),
      ),
    );
  }
}
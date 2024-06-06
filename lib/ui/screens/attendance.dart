import 'package:csoc_flutter/ui/widgets/app_bar.dart';
import 'package:csoc_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final  day  = DateTime.now().weekday;
  final date = DateTime.now().toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const CustomAppBar(title: 'Attendance'
          ,backgroundColor: AppColors.primaryColor
          , actions:[]//TODO: Add the date selector icon in the app bar.
           ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 150 ,
              width: double.infinity,
              child:   Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.circle_sharp,
                          color: Colors.green ),
                      Text('Present')
                    ],
                  ), Column(
                    children: [
                      Icon(Icons.circle_sharp,
                          color: Colors.red ),
                      Text('Absent')
                    ],
                  ), Column(
                    children: [
                      Icon(Icons.circle_sharp,
                          color: Colors.blue ),
                      Text('Proxied')
                    ],
                  ), Column(
                    children: [
                      Icon(Icons.circle_sharp,
                          color: Colors.yellow ),
                      Text('Cancelled')
                    ],
                  ),

                ],
              ),
            ),
           const SingleChildScrollView(
              child: Column(
                children: [
                  //TODO : Add the logic to initialize the scrollview with the classes of user..
                ],
              ),
            ),
             TextButton(onPressed:()=>{} //Todo Add the logic to add extra class ,
                 , style:  ButtonStyle(
                   shape:  WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                   backgroundColor: const WidgetStatePropertyAll(Colors.grey)
                ),
               child: const Text('Add Extra class'),
            ),
          ],
        ),
      ),
      
    );
  }
}

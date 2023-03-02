import 'package:attenda/core/colors.dart';
import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  const InfoContainer(
      {Key? key, required this.title, required this.icon, required this.num,this.color,this.textColor})
      : super(key: key);

  final int num;
  final String title;
  final IconData icon;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .16,
      width: MediaQuery.of(context).size.width * .17,
      decoration:  BoxDecoration(
          color:color?? Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:BorderRadius.circular(5) ,
                ),
                child:  Icon(
                  icon,
                  color: MyColors.primary,
                  size: 40,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$num',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color:textColor?? MyColors.grey,
                        fontWeight: FontWeight.w200,
                        fontSize: 14),
                  )
                ],
              ),
            ],
          )),
    );
  }
}

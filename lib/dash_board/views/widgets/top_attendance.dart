import 'package:attenda/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TobAttendance extends StatelessWidget {
  const TobAttendance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .3,
      width: MediaQuery.of(context).size.width * .24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top 5 Attendant',
                style: Theme.of(context).textTheme.bodySmall!
                    .copyWith(color: Colors.black,fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Zeaad Ayman',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '30',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                        ),
                        TextSpan(
                            text: 'days',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  )
                ],
              ),
              const Divider(
                thickness: 1,
                color: MyColors.grey,
                indent: 2,
                endIndent: 2,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Zeaad Ayman',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '30',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        TextSpan(
                            text: 'days',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  )
                ],
              ),
              const Divider(
                thickness: 1,
                color: MyColors.grey,
                indent: 2,
                endIndent: 2,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Zeaad Ayman',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '30',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        TextSpan(
                            text: 'days',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  )
                ],
              ),
              const Divider(
                thickness: 1,
                color: MyColors.grey,
                indent: 2,
                endIndent: 2,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Zeaad Ayman',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '30',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        TextSpan(
                            text: 'days',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  )
                ],
              ),
              const Divider(
                thickness: 1,
                color: MyColors.grey,
                indent: 2,
                endIndent: 2,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Zeaad Ayman',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '30',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        TextSpan(
                            text: 'days',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  )
                ],
              ),
              const Divider(
                thickness: 1,
                color: MyColors.grey,
                indent: 2,
                endIndent: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

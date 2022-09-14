import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monsey/common/constant/colors.dart';
import 'package:monsey/common/constant/styles.dart';
import 'package:monsey/common/widget/animation_click.dart';

import '../common/constant/images.dart';

mixin AppWidget {
  static double getHeightScreen(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getWidthScreen(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Future<void> showLoading({required BuildContext context}) async {
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      barrierColor: black.withOpacity(0.1),
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: const CupertinoActivityIndicator(
              animating: true,
            ));
      },
    );
  }

  static Future<void> showDialogCustom(String title,
      {required BuildContext context, Function()? remove}) async {
    showDialog<dynamic>(
      context: context,
      builder: (context) {
        final height = AppWidget.getHeightScreen(context);
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: white,
          child: Container(
            padding: const EdgeInsets.all(30),
            height: height / 116 * 56,
            child: Column(
              children: [
                Expanded(child: Image.asset(confuse)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: headline(context: context),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppWidget.typeButtonStartAction(
                          context: context,
                          input: 'Yes',
                          bgColor: emerald,
                          textColor: white,
                          borderRadius: 48,
                          onPressed: () {
                            remove!();
                          }),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48),
                            ),
                            side: const BorderSide(color: purplePlum)),
                        child: Text('No',
                            textAlign: TextAlign.center,
                            style: headline(color: purplePlum)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static PreferredSizeWidget createSimpleAppBar(
      {required BuildContext context,
      bool hasPop = true,
      Color? backgroundColor,
      bool hasLeading = true,
      String? title,
      Widget? action,
      Color? colorTitle,
      Color? arrowColor,
      Function()? onTap,
      Function()? onBack}) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor ?? white,
      leading: hasLeading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimationClick(
                  child: GestureDetector(
                    onTap: () {
                      if (hasPop) {
                        if (onBack != null) {
                          onBack();
                        } else {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: Image.asset(
                      icArrowLeft,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                      color: arrowColor ?? black,
                    ),
                  ),
                ),
              ],
            )
          : const SizedBox(),
      centerTitle: true,
      title: title == null
          ? null
          : Text(
              title,
              style: colorTitle == null
                  ? headline(context: context)
                  : headline(color: colorTitle),
            ),
      actions: [
        onTap != null
            ? Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: onTap,
                        icon: action ??
                            const Icon(
                              Icons.add,
                              color: white,
                              size: 24,
                            ))
                  ],
                ),
              )
            : const SizedBox()
      ],
    );
  }

  static Widget typeButtonStartAction(
      {double? fontSize,
      required BuildContext context,
      double? height,
      double? vertical,
      double? horizontal,
      Function()? onPressed,
      Color? bgColor,
      Color? borderColor,
      double miniSizeHorizontal = double.infinity,
      Color? textColor,
      String? input,
      FontWeight? fontWeight,
      double borderRadius = 48,
      double sizeAsset = 16,
      Color? colorAsset,
      String? icon}) {
    return AnimationClick(
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
              vertical: vertical ?? 16, horizontal: horizontal ?? 0),
          side: BorderSide(color: borderColor ?? white),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          backgroundColor: bgColor,
          minimumSize: Size(miniSizeHorizontal, 0),
        ),
        onPressed: onPressed,
        child: icon == null
            ? Text(
                input!,
                textAlign: TextAlign.center,
                style: headline(context: context, color: textColor),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      SizedBox(
                          width: constraints.maxWidth * 0.3,
                          child: Image.asset(
                            icon,
                            width: sizeAsset,
                            height: sizeAsset,
                            color: colorAsset,
                          )),
                      Text(
                        input!,
                        textAlign: TextAlign.center,
                        style: headline(context: context, color: textColor),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  static SnackBar customSnackBar({required String content, Color? color}) {
    return SnackBar(
      duration: const Duration(milliseconds: 400),
      backgroundColor: color ?? emerald,
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: body(color: white),
      ),
    );
  }

  static Widget divider(BuildContext context, {double vertical = 24}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical),
      child: const Divider(
        thickness: 1,
        color: grey6,
      ),
    );
  }

//   static Widget premium(BuildContext context) {
//     UserModel? userModel;
//     return BlocBuilder<SaveInfoUserBloc, SaveInfoUserState>(
//       builder: (context, state) {
//         if (state is SaveInfoUserSuccess) {
//           userModel = state.userModel;
//         }
//         return userModel!.isPremium!
//             ? const SizedBox()
//             : GestureDetector(
//                 onTap: () {
//                   if (userModel!.money! < 10000) {
//                     DialogInvite().showDialogInvite(
//                         context: context,
//                         pS: 'RUN NOW',
//                         nS: 'OK,THANKS',
//                         pF: () {
//                           Navigator.pushNamedAndRemoveUntil(
//                               context, Routes.homeScreen, (route) => false,
//                               arguments: const HomeScreen(currentIndex: 1));
//                         },
//                         nF: () {
//                           Navigator.of(context).pop(true);
//                         },
//                         content:
//                             'You have ${userModel!.money!} Point and missing ${10000 - userModel!.money!} Point to exchange go premium');
//                   } else {
//                     DialogInvite().showDialogInvite(
//                         context: context,
//                         pS: 'ACCEPT',
//                         nS: 'NO,THANKS',
//                         pF: () {
//                           final User user = FirebaseAuth.instance.currentUser!;
//                           user.getIdToken().then((token) async {
//                             await Config.initializeClient(token)
//                                 .value
//                                 .mutate(MutationOptions(
//                                     document: gql(Mutations.updatePremium()),
//                                     variables: <String, dynamic>{
//                                       'id': user.uid,
//                                       'is_premium': true,
//                                       'money': userModel!.money! - 10000
//                                     }))
//                                 .then((value) {
//                               Navigator.of(context).pop(true);
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                   AppWidget.customSnackBar(
//                                       content:
//                                           'You registered Premium successfully',
//                                       color: caribbeanGreen));
//                             });
//                             Config.initializeClient(token)
//                                 .value
//                                 .query(QueryOptions(
//                                     document: gql(Queries.getInfoUser),
//                                     variables: <String, dynamic>{
//                                       'id': user.uid
//                                     }))
//                                 .then((value) {
//                               BlocProvider.of<SaveInfoUserBloc>(context).add(
//                                   SaveInfoEvent(
//                                       userModel: UserModel.fromJson(
//                                           value.data!['User'][0])));
//                             });
//                           });
//                         },
//                         nF: () {
//                           Navigator.of(context).pop(true);
//                         },
//                         content:
//                             'Do you want to exchange 10,000P to get go premium ?');
//                   }
//                 },
//                 child: Container(
//                     height: 98,
//                     padding: const EdgeInsets.all(16),
//                     margin: const EdgeInsets.symmetric(vertical: 16),
//                     decoration: BoxDecoration(
//                         color: caribbeanGreen,
//                         borderRadius: BorderRadius.circular(16)),
//                     alignment: Alignment.center,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 8),
//                                   child: Image.asset('images/premium@3x.png',
//                                       width: 28, height: 28),
//                                 ),
//                                 Text(
//                                   'Go Premium',
//                                   style: AppWidget.simpleTextFieldStyle(
//                                       fontSize: 20,
//                                       height: 23.87,
//                                       color: white,
//                                       fontWeight: FontWeight.w600),
//                                 )
//                               ],
//                             ),
//                             Image.asset('images/arrow-right-o@3x.png',
//                                 width: 24, height: 24, color: white)
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8),
//                           child: Text('10,000 Point to Remove Ads',
//                               style: AppWidget.simpleTextFieldStyle(
//                                   fontSize: 16,
//                                   height: 24,
//                                   fontWeight: FontWeight.w600,
//                                   color: white.withOpacity(0.7))),
//                         )
//                       ],
//                     )),
//               );
//       },
//     );
//   }

//   static Future<void> showDialogSetting(BuildContext context,
//       {String? content}) async {
//     await showDialog<dynamic>(
//       context: context,
//       builder: (context) {
//         final height = AppWidget.getHeightScreen(context);
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(24),
//           ),
//           backgroundColor: white,
//           child: Container(
//             padding: const EdgeInsets.all(30),
//             height: height / 116 * 56,
//             child: Column(
//               children: [
//                 Expanded(child: Image.asset('images/group@3x.png')),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 24),
//                   child: Text(
//                     content ?? EnvValue.requestLocation,
//                     textAlign: TextAlign.center,
//                     style: AppWidget.simpleTextFieldStyle(
//                         fontSize: 16, height: 24, color: black),
//                   ),
//                 ),
//                 AppWidget.typeButtonStartAction(
//                     input: 'Go to Setting',
//                     horizontal: 24,
//                     miniSizeHorizontal: 0,
//                     bgColor: ultramarineBlue,
//                     onPressed: () async {
//                       await openAppSettings();
//                     })
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
}

import 'package:currency_picker/currency_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monsey/common/constant/images.dart';
import 'package:monsey/common/constant/styles.dart';
import 'package:monsey/common/route/routes.dart';
import 'package:monsey/common/widget/animation_click.dart';
import 'package:monsey/feature/onboarding/bloc/user/bloc_user.dart';

import '../../../app/widget_support.dart';
import '../../../common/constant/colors.dart';
import '../../../translations/export_lang.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settings = [
      // <String, dynamic>{
      //   'icon': icWallet,
      //   'name': LocaleKeys.wallet.tr(),
      //   'onTap': () {
      //     Navigator.of(context).pushNamed(Routes.dashboard,
      //         arguments: const Dashboard(hasLeading: true));
      //   }
      // },
      <String, dynamic>{
        'icon': icCurrency,
        'name': LocaleKeys.currency.tr(),
        'onTap': () async {
          final currency = await Navigator.of(context)
              .pushNamed(Routes.currency) as Currency?;
          if (currency != null) {
            context
                .read<UserBloc>()
                .add(UpdateUser(currency.code, currency.symbol));
          }
        }
      },
      <String, dynamic>{
        'icon': icLock,
        'name': LocaleKeys.logout.tr(),
        'onTap': () async {
          await FirebaseAuth.instance.signOut();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.onBoarding, (route) => false);
        }
      }
    ];
    return Scaffold(
      backgroundColor: white,
      appBar: AppWidget.createSimpleAppBar(
          context: context,
          title: LocaleKeys.profile.tr(),
          hasLeading: false,
          // onTap: () {},
          action: Image.asset(icPencilEdit,
              width: 24, height: 24, color: purplePlum)),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserLoaded) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(state.user.avatar),
                      radius: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        state.user.name,
                        style: title3(context: context),
                      ),
                    ),
                    Text(
                      state.user.email,
                      style: body(color: grey3),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 16),
                    //   child: Row(
                    //     children: [
                    //       const Expanded(child: SizedBox()),
                    //       Expanded(
                    //         flex: 2,
                    //         child: AppWidget.typeButtonStartAction(
                    //             context: context,
                    //             input: LocaleKeys.getPremium.tr(),
                    //             onPressed: () {
                    //               Navigator.of(context)
                    //                   .pushNamed(Routes.premium);
                    //             },
                    //             bgColor: emerald,
                    //             textColor: white,
                    //             sizeAsset: 24,
                    //             colorAsset: white,
                    //             icon: icAward),
                    //       ),
                    //       const Expanded(child: SizedBox()),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 16),
                      child: Text(
                        LocaleKeys.accountSettings.tr(),
                        style: headline(color: grey2),
                      ),
                    ),
                    ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox();
                      },
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: settings.length,
                      itemBuilder: (context, index) {
                        return AnimationClick(
                          function: settings[index]['onTap'],
                          child: ListTile(
                            leading: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  settings[index]['icon'],
                                  width: 24,
                                  height: 24,
                                  color: purplePlum,
                                ),
                              ],
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    settings[index]['name'],
                                    style: body(context: context),
                                  ),
                                ),
                                if (index == 0) ...[
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: grey5,
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Text(
                                      BlocProvider.of<UserBloc>(context)
                                              .userModel!
                                              .currencyCode ??
                                          'USD',
                                      style: subhead(color: grey1),
                                    ),
                                  )
                                ],
                                const Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  size: 24,
                                  color: grey4,
                                )
                              ],
                            ),
                            subtitle: AppWidget.divider(context, vertical: 8),
                          ),
                        );
                      },
                    )
                  ],
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

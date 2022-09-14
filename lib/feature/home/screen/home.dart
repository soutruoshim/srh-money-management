import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:monsey/common/constant/images.dart';
import 'package:monsey/common/graphql/queries.dart';
import 'package:monsey/common/model/user_model.dart';
import 'package:monsey/feature/home/bloc/wallets/bloc_wallets.dart';

import '../../../common/graphql/config.dart';
import '../../../common/graphql/subscription.dart';
import '../../onboarding/bloc/user/bloc_user.dart';
import '../../profile/screen/profile.dart';
import '../widget/home_widget.dart';
import 'dashboard.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User firebaseUser = FirebaseAuth.instance.currentUser!;
  List<Widget> listWidget = [];
  int _currentIndex = 0;

  Future<void> listenWallets() async {
    final String token = await firebaseUser.getIdToken();
    Config.initializeClient(token)
        .value
        .subscribe(SubscriptionOptions(
            document: gql(Subscription.listenWallets),
            variables: <String, dynamic>{'user_uuid': firebaseUser.uid}))
        .listen((event) {
      if (event.data != null) {
        context.read<WalletsBloc>().add(InitialWallets());
      }
    });
  }

  Future<UserModel?> getUserInfo() async {
    UserModel? userModel;
    final String token = await firebaseUser.getIdToken();
    Config.initializeClient(token)
        .value
        .query(QueryOptions(
            document: gql(Queries.getUser),
            variables: <String, dynamic>{'uuid': firebaseUser.uid}))
        .then((value) {
      if (value.data!.isNotEmpty && value.data!['User'].length > 0) {
        userModel = UserModel.fromJson(value.data!['User'][0]);
        context.read<UserBloc>().add(GetUser(userModel!));
      }
    });
    return userModel;
  }

  @override
  void initState() {
    getUserInfo();
    listenWallets();
    listWidget = [
      const Dashboard(),
      // const Chart(),
      const Profile(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listWidget.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: [
          createItemNav(context, icHome, 'Dashboard'),
          // createItemNav(context, icChart, 'Chart'),
          createItemNav(context, icAccount, 'Account'),
        ],
      ),
    );
  }
}

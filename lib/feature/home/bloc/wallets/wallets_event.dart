import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:monsey/common/model/wallet_model.dart';

@immutable
abstract class WalletsEvent extends Equatable {
  const WalletsEvent();
}

class InitialWallets extends WalletsEvent {
  @override
  List<Object> get props => [];
}

class CreateWallet extends WalletsEvent {
  const CreateWallet(this.wallet);

  final WalletModel wallet;

  @override
  List<Object> get props => [wallet];
}

class EditWallet extends WalletsEvent {
  const EditWallet(this.wallet);

  final WalletModel wallet;

  @override
  List<Object> get props => [wallet];
}

class RemoveWallet extends WalletsEvent {
  const RemoveWallet(this.wallet);

  final WalletModel wallet;

  @override
  List<Object> get props => [wallet];
}

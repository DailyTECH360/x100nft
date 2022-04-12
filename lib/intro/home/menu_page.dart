import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/twofa_page.dart';
import '../../data/services/wg_global/bottom_bar/page/home_page.dart';
import '../../data/services/wg_global/form_page.dart';
import '../../data/services/wg_global/init_set.dart';
import '../../data/services/wg_global/pinput.dart';
import '../../data/services/wg_global/screen_lock.dart';
import '../../data/services/wg_global/vk_multi.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';
import '../../modules/deposit/deposit_page.dart';
import '../../modules/income/in_page.dart';
import '../../modules/lending/mylending_page.dart';
import '../../modules/profile/profile_page.dart';
import '../../modules/staking/mystaking_page.dart';
import '../../modules/support/support_page.dart';
import '../../modules/swap/swap_page.dart';
import '../../modules/team/team_page.dart';
import '../../modules/wallet/wallet_page.dart';

class Menu extends GetView<UserCtr> {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ListView(
        primary: false,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(gradient: AppColors.linearG1),
            padding: const EdgeInsets.all(24),
            child: Center(child: Wg.logoBoxCircle(pic: 'assets/brand/192.png', maxH: 120, padding: 8, color: Colors.black54, func: () => refreshApp())),
          ),
          MenuList(name: myProfile, icon: Icons.account_circle, page: const ProfilePage()),
          MenuList(name: team, icon: Icons.account_tree_sharp, page: const TeamPage()),
          // const MenuList(name: 'Edu data', icon: Icons.school, page: null),
          // const MenuList(name: 'Shop', icon: Icons.shopping_cart, page: null),
          MenuList(name: dep, icon: Icons.payments, page: const DepositPage()),
          MenuList(name: lending, icon: Icons.add_chart, page: const LendingPage()),
          MenuList(name: staking, icon: Icons.leaderboard, page: const StakingPage()),
          MenuList(name: walletHis, icon: Icons.account_balance, page: const WalletPage()),
          MenuList(name: income, icon: Icons.account_balance_wallet, page: const IncomePage()),
          MenuList(name: menuTwoFa, icon: Icons.settings, page: const Set2faPage()),
          MenuList(name: support, icon: Icons.support_agent, page: const SupportPage()),
          ListTile(
            title: Text(exitApp, style: const TextStyle(color: Colors.white)),
            leading: Icon(Icons.exit_to_app, color: AppColors.primaryLight),
            horizontalTitleGap: 0.0,
            onTap: () {
              controller.signOut();
              controller.onClose();
            },
          ),
          Visibility(
            visible: controller.userDB!.role == 'dev',
            child: Column(
              children: const [
                Divider(color: Colors.white24, height: 24, thickness: 1),
                MenuList(name: 'Set Page', icon: Icons.add, page: SetInitPage()),
                MenuList(name: 'Form Page', icon: Icons.add, page: FormPage()),
                MenuList(name: 'Virtual keyboard', icon: Icons.add, page: VirtualkeyboardPage(getText: wAmount)),
                MenuList(name: 'PIN', icon: Icons.add, page: PinPutView()),
                MenuList(name: 'Screen Lock', icon: Icons.add, page: ScreenLockPage()),
                MenuList(name: 'Swap', icon: Icons.add, page: SwapPage()),
                MenuList(name: 'Bottom Bar', icon: Icons.add, page: BottomBarPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuList extends StatelessWidget {
  final String name;
  final dynamic page;
  final IconData? icon;
  const MenuList({Key? key, required this.name, required this.page, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name, style: const TextStyle(color: Colors.white)),
      leading: Icon(icon ?? Icons.navigate_next, color: AppColors.primaryLight),
      horizontalTitleGap: 0.0,
      onTap: () {
        Get.back();
        Get.to(page);
      },
    );
  }
}

Future wAmount(String text) async {
  // await updateAnyField(coll: 'settings', docId: 'set', data: {'dsdsds': text});
  debugPrint('Text Input: $text');
}

import 'package:flutter/material.dart';
import '../../data/utils.dart';
import '../../data/models/models.dart';
import 'team_item.dart';

// ignore: must_be_immutable
class TeamNexPage2 extends StatelessWidget {
  List<UserModel> teamList;
  UserModel userChoose;
  String? pkey;
  TeamNexPage2({Key? key, required this.teamList, required this.userChoose, this.pkey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Team of: ${stringDot(text: userChoose.name!)}', overflow: TextOverflow.clip),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Children of ${stringDot(text: userChoose.name!)} = ${teamList.length}', style: TextStyle(color: AppColors.primaryLight)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: teamList.length,
                  itemBuilder: (_, index) {
                    return TeamItem(userData: teamList[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

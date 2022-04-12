class RankModel {
  int? rank;
  int? investPack;
  bool? dkActive;
  double? dkVolumeMe;
  double? dkVolumeTeam;
  int? dkTotalF1BronzeL;
  int? dkTotalF1BronzeR;
  int? dkNhanhYeu;

  RankModel({
    this.rank,
    this.investPack,
    this.dkActive,
    this.dkVolumeMe,
    this.dkVolumeTeam,
    this.dkTotalF1BronzeL,
    this.dkTotalF1BronzeR,
    this.dkNhanhYeu,
  });

  // LevelModel.fromJson(Map<String, dynamic> json) {
  //   open = (json['open'] as num)?.toDouble();
  //   high = (json['high'] as num)?.toDouble();
  //   low = (json['low'] as num)?.toDouble();
  //   close = (json['close'] as num)?.toDouble();
  //   vol = (json['vol'] as num)?.toDouble();
  //   time = DateTime.fromMillisecondsSinceEpoch(((json['id'] as num).toInt()) * 1000);
  // }
}

class StatisticsModel {
  final int totalVoters;
  final int voted;
  final int notVoted;
  final int activeVoters;
  final int inactiveVoters;

  StatisticsModel({
    required this.totalVoters,
    required this.voted,
    required this.notVoted,
    required this.activeVoters,
    required this.inactiveVoters,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      totalVoters: json['total_voters'] ?? 0,
      voted: json['voted'] ?? 0,
      notVoted: json['not_voted'] ?? 0,
      activeVoters: json['active_voters'] ?? 0,
      inactiveVoters: json['inactive_voters'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_voters': totalVoters,
      'voted': voted,
      'not_voted': notVoted,
      'active_voters': activeVoters,
      'inactive_voters': inactiveVoters,
    };
  }

  factory StatisticsModel.empty() {
    return StatisticsModel(
      totalVoters: 0,
      voted: 0,
      notVoted: 0,
      activeVoters: 0,
      inactiveVoters: 0,
    );
  }

  StatisticsModel copyWith({
    int? totalVoters,
    int? voted,
    int? notVoted,
    int? activeVoters,
    int? inactiveVoters,
  }) {
    return StatisticsModel(
      totalVoters: totalVoters ?? this.totalVoters,
      voted: voted ?? this.voted,
      notVoted: notVoted ?? this.notVoted,
      activeVoters: activeVoters ?? this.activeVoters,
      inactiveVoters: inactiveVoters ?? this.inactiveVoters,
    );
  }
}

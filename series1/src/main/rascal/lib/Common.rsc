module lib::Common

public map[str, real] getRiskProfile() {
    return (
        "low": 0.0,
        "moderate": 0.0,
        "high": 0.0,
        "very_high": 0.0
    );
}

// Maps values of moderate, high and very high
public list[tuple[num, num, num, str]] getRankings() {
    return [
		<25, 0, 0, "++">,
		<30, 5, 0, "+">,
		<40, 10, 0, "o">,
		<50, 15, 5, "-">,
		<100, 100, 100, "--">
	];
}

public list[tuple[num, num, str]] getDuplicationRankings() {
    return [
        <0, 3, "++">,
        <3, 5, "+">,
        <5, 10, "0">,
        <10, 20, "-">,
        <20, 100, "--">
    ];
}
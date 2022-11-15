module metrics::maintainability::Aggregations

import Map;

map[str, int] weights = (
    "++" : 2,
    "+" : 1,
    "o" : 0,
    "-" : -1,
    "--" : -2
);

str aggregateAnalysability(str volume, str duplicates, str unitSize, str unitTesting) {
    int avg = (weights[volume] + weights[duplicates] + weights[unitSize] + weights[unitTesting]) / 4;

    return invertUnique(weights)[avg];
}

str aggregateChangeability(str complexity, str duplicates) {
    int avg = (weights[complexity] + weights[duplicates]) / 2;

    return invertUnique(weights)[avg];
}

str aggregateStability(str unitTesting) {
    int avg = weights[unitTesting];

    return invertUnique(weights)[avg];
}

str aggregateTestability(str complexity, str unitSize, str unitTesting) {
    int avg = (weights[complexity] + weights[unitSize] + weights[unitTesting]) / 3;

    return invertUnique(weights)[avg];
}
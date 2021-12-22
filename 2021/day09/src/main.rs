use std::collections::BTreeSet;

fn neighbors(i: usize, j: usize, nrows: usize, ncols: usize) -> [Option<(usize, usize)>; 4] {
    let left = if j > 0 { Some((i, j - 1)) } else { None };
    let right = if j < (ncols - 1) {
        Some((i, j + 1))
    } else {
        None
    };
    let up = if i > 0 { Some((i - 1, j)) } else { None };
    let down = if i < (nrows - 1) {
        Some((i + 1, j))
    } else {
        None
    };

    [left, right, up, down]
}

fn low_points(input: &[Vec<u8>]) -> Vec<(usize, usize)> {
    let nrows = input.len();
    let ncols = input[0].len();
    let mut points = Vec::new();

    for i in 0..nrows {
        for j in 0..ncols {
            let min = neighbors(i, j, nrows, ncols)
                .into_iter()
                .flatten()
                .map(|(i, j)| input[i][j])
                .fold(0xff, |a, b| a.min(b));

            if input[i][j] < min {
                points.push((i, j));
            }
        }
    }

    points
}

fn part1(input: &[Vec<u8>]) -> u64 {
    low_points(input)
        .into_iter()
        .map(|(i, j)| (input[i][j] + 1) as u64)
        .sum()
}

fn measure_basin(input: &[Vec<u8>], i: usize, j: usize) -> usize {
    let nrows = input.len();
    let ncols = input[0].len();
    let mut visited = BTreeSet::new();
    let mut stack = vec![(i, j)];

    while !stack.is_empty() {
        let (i, j) = stack.pop().unwrap();
        visited.insert((i, j));
        stack.extend(
            neighbors(i, j, nrows, ncols)
                .into_iter()
                .flatten()
                .filter(|x| !visited.contains(x))
                .filter(|&(ii, jj)| (input[ii][jj] > input[i][j]) && (input[ii][jj] != 9)),
        );
    }

    visited.len()
}

fn part2(input: &[Vec<u8>]) -> usize {
    let mut basin_sizes = low_points(input)
        .into_iter()
        .map(|(i, j)| measure_basin(input, i, j))
        .collect::<Vec<_>>();
    basin_sizes.sort_unstable();
    basin_sizes.reverse();

    basin_sizes[0] * basin_sizes[1] * basin_sizes[2]
}

fn main() {
    let input = include_str!("../input.txt")
        .lines()
        .map(|l| l.chars().map(|c| c as u8 - b'0').collect::<Vec<_>>())
        .collect::<Vec<_>>();

    println!("{}", part1(&input));
    println!("{}", part2(&input));
}

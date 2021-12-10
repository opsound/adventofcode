fn main() {
    let positions = include_str!("../input.txt")
        .trim()
        .split(',')
        .map(|s| s.parse::<i32>().unwrap())
        .collect::<Vec<_>>();

    let max = *positions.iter().max().unwrap();

    let part1 = (0..=max)
        .map(|x| positions.iter().map(|p| (x - p).abs()).sum::<i32>())
        .min()
        .unwrap();

    println!("{}", part1);

    let part2 = (0..=max)
        .map(|x| {
            positions
                .iter()
                .map(|p| {
                    let dist = (x - p).abs();
                    (dist * dist + dist) / 2
                })
                .sum::<i32>()
        })
        .min()
        .unwrap();

    println!("{}", part2);
}

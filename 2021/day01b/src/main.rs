fn main() {
    println!(
        "{:?}",
        include_str!("../input.txt")
            .split_whitespace()
            .map(|s| s.parse::<i64>().unwrap())
            .collect::<Vec<_>>()
            .windows(3)
            .map(|x| x.iter().sum::<i64>())
            .collect::<Vec<_>>()
            .windows(2)
            .filter(|x| x[1] > x[0])
            .count()
    );
}

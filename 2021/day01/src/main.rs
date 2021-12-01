fn main() {
    println!(
        "{}",
        include_str!("../input.txt")
            .split_whitespace()
            .map(|s| s.parse::<i64>().unwrap())
            .collect::<Vec<_>>()
            .as_slice()
            .windows(2)
            .filter(|x| x[1] > x[0])
            .count()
    );
}

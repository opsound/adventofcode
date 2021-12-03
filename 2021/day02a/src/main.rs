fn main() {
    let mut horiz = 0;
    let mut depth = 0;
    for l in include_str!("../input.txt").lines() {
        let mut split = l.split_whitespace();
        let dir = split.next().unwrap();
        let delta = split.next().unwrap().parse::<i64>().unwrap();
        match dir {
            "forward" => horiz += delta,
            "down" => depth += delta,
            "up" => depth -= delta,
            _ => unreachable!(),
        }
    }
    println!("{:?}", horiz * depth);
}

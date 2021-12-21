#[derive(Debug)]
struct Entry {
    patterns: Vec<u8>,
    output: Vec<u8>,
}

fn part1(input: &[Entry]) -> usize {
    input
        .iter()
        .map(|e| e.output.iter())
        .flatten()
        .filter(|x| matches!(x.count_ones(), |2| 4 | 3 | 7))
        .count()
}

fn to_binary(s: &str) -> u8 {
    s.chars()
        .map(|c| 1 << (c as u8 - b'a'))
        .fold(0, |a, b| a | b)
}

fn part2(input: &[Entry]) -> usize {
    let mut sum = 0;

    for entry in input {
        let vals = &entry.patterns;

        let a = (vals[1] & !vals[0]) & 0x7f;
        let cf = (vals[1] & !a) & 0x7f;
        let bd = (vals[2] & !vals[1]) & 0x7f;
        let cde = (!vals[8] | !vals[7] | !vals[6]) & 0x7f;
        let bcef = (!vals[3] | !vals[4] | !vals[5]) & 0x7f;
        let d = (cde & !bcef) & 0x7f;
        let bf = (bcef & !cde) & 0x7f;
        let c = (cf & !bf) & 0x7f;
        let b = (bd & !d) & 0x7f;
        let e = (cde & !d & !c) & 0x7f;
        let f = (bf & !b) & 0x7f;
        let g = 0x7f & !(a | b | c | d | e | f);

        #[rustfmt::skip]
        let cypher = [
            (        c |         f    , 1), // 0
            (a |     c |         f    , 7), // 1
            (    b | c | d |     f    , 4), // 2
            (a |     c | d | e |     g, 2), // 3
            (a |     c | d |     f | g, 3), // 4
            (a | b |     d | f |     g, 5), // 5
            (a | b |     d | e | f | g, 6), // 6
            (a | b | c |     e | f | g, 0), // 7
            (a | b | c |     d | f | g, 9), // 8
            (a | b | c | d | e | f | g, 8), // 9
        ];

        sum += entry
            .output
            .iter()
            .map(|x| {
                cypher
                    .iter()
                    .filter(|(a, _)| x == a)
                    .map(|(_, b)| b)
                    .next()
                    .unwrap()
            })
            .fold(0, |x, y| x * 10 + y);
    }

    sum
}

fn main() {
    let input: Vec<Entry> = include_str!("../input.txt")
        .lines()
        .map(|l| {
            let mut halves = l.split('|').map(|x| {
                x.trim()
                    .split(' ')
                    .map(|s| to_binary(s))
                    .collect::<Vec<u8>>()
            });

            let mut patterns = halves.next().unwrap();
            patterns.sort_by_key(|x| x.count_ones());

            Entry {
                patterns,
                output: halves.next().unwrap(),
            }
        })
        .collect();

    println!("{}", part1(&input));
    println!("{}", part2(&input));
}

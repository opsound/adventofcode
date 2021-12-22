enum SyntaxError {
    FirstIncorrect(char),
    ClosingChars(Vec<char>),
}

fn first_incorrect(line: &str) -> SyntaxError {
    let mut stack = Vec::new();

    for c in line.chars() {
        match c {
            open @ ('<' | '{' | '[' | '(') => stack.push(match open {
                '<' => '>',
                '{' => '}',
                '[' => ']',
                '(' => ')',
                _ => unreachable!(),
            }),
            close @ ('>' | '}' | ']' | ')') => {
                if stack.pop().unwrap() != close {
                    return SyntaxError::FirstIncorrect(close);
                }
            }
            _ => unreachable!(),
        }
    }

    stack.reverse();
    SyntaxError::ClosingChars(stack)
}

fn part1(lines: &[&str]) -> u64 {
    lines
        .iter()
        .filter_map(|l| match first_incorrect(l) {
            SyntaxError::FirstIncorrect(c) => Some(c),
            _ => None,
        })
        .map(|x| match x {
            ')' => 3,
            ']' => 57,
            '}' => 1197,
            '>' => 25137,
            _ => unreachable!(),
        })
        .sum()
}

fn part2(lines: &[&str]) -> u64 {
    let mut scores = lines
        .iter()
        .filter_map(|l| match first_incorrect(l) {
            SyntaxError::ClosingChars(chars) => Some(chars),
            _ => None,
        })
        .map(|chars| {
            chars.iter().fold(0_u64, |a, b| {
                let value = match b {
                    ')' => 1,
                    ']' => 2,
                    '}' => 3,
                    '>' => 4,
                    _ => unreachable!(),
                };
                (a * 5) + value
            })
        })
        .collect::<Vec<_>>();

    scores.sort_unstable();
    scores[scores.len() / 2]
}

fn main() {
    let input = include_str!("../input.txt").lines().collect::<Vec<_>>();
    println!("{}", part1(&input));
    println!("{}", part2(&input));
}

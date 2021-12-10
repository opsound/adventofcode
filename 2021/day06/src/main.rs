use std::iter;

fn part1(mut fish: Vec<u8>) -> usize {
    for _ in 0..80 {
        let mut new_fish = 0;

        for f in &mut fish {
            match f {
                1..=8 => *f -= 1,
                0 => {
                    *f = 6;
                    new_fish += 1;
                }
                _ => unreachable!(),
            }
        }

        fish.extend(iter::repeat(8).take(new_fish));
    }

    fish.len()
}

fn part2(fish: &[u8]) -> usize {
    let mut ages = vec![0; 9];

    for &f in fish {
        ages[f as usize] += 1;
    }

    for _ in 0..256 {
        ages.rotate_left(1);
        ages[6] += ages[8];
    }

    ages.iter().sum()
}

fn main() {
    let fish = include_str!("../input.txt")
        .trim()
        .split(',')
        .map(|s| s.parse::<u8>().unwrap())
        .collect::<Vec<_>>();

    println!("{}", part1(fish.clone()));
    println!("{}", part2(&fish));
}

fn adjacent(i: usize, j: usize, nrows: usize, ncols: usize) -> [Option<(usize, usize)>; 8] {
    [
        (-1_isize, 0_isize),
        (1, 0),
        (0, -1),
        (0, 1),
        (-1, -1),
        (-1, 1),
        (1, 1),
        (1, -1),
    ]
    .map(|(di, dj)| (i as isize + di, j as isize + dj))
    .map(|(i, j)| {
        if i < 0 || j < 0 || i >= nrows as isize || j >= ncols as isize {
            None
        } else {
            Some((i as usize, j as usize))
        }
    })
}

fn step(input: &mut [Vec<u8>]) -> u64 {
    let nrows = input.len();
    let ncols = input[0].len();
    let mut stack = Vec::new();

    for i in 0..nrows {
        for j in 0..ncols {
            stack.push((i, j));
        }
    }

    while !stack.is_empty() {
        let (i, j) = stack.pop().unwrap();
        if input[i][j] != 0xff {
            input[i][j] += 1;
        }
        if input[i][j] == 10 {
            input[i][j] = 0xff;
            stack.extend(
                adjacent(i, j, nrows, ncols)
                    .iter()
                    .flatten()
                    .filter(|(i, j)| input[*i][*j] != 0xff),
            );
        }
    }

    let mut n_flashed = 0;

    for x in input.iter_mut().flatten() {
        if *x > 9 {
            *x = 0;
            n_flashed += 1;
        }
    }

    n_flashed
}

fn part1(input: &[Vec<u8>]) -> u64 {
    let mut input = input.to_owned();
    let mut n_flashes = 0;
    for _ in 0..100 {
        n_flashes += step(&mut input);
    }
    n_flashes
}

fn part2(input: &[Vec<u8>]) -> u64 {
    let mut input = input.to_owned();
    let mut step_count = 0;
    loop {
        step_count += 1;
        if step(&mut input) == 100 {
            break;
        }
    }
    step_count
}

fn main() {
    let input = include_str!("../input.txt")
        .lines()
        .map(|l| l.chars().map(|c| c as u8 - b'0').collect::<Vec<_>>())
        .collect::<Vec<_>>();
    println!("{}", part1(&input));
    println!("{}", part2(&input));
}

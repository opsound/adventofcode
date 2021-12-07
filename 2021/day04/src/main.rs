const N_ROWS: u64 = 5;
const N_COLS: u64 = 5;
const ROW_WIN: u64 = 0b11111;
const COL_WIN: u64 = 0b0000100001000010000100001;

#[derive(Debug)]
struct Board {
    squares: Vec<u32>,
    chosen: u64,
}

impl Board {
    fn new(squares: &[u32]) -> Self {
        Self {
            squares: squares.to_vec(),
            chosen: 0,
        }
    }

    fn set(&mut self, val: u32) {
        for (i, &x) in self.squares.iter().enumerate() {
            if x == val {
                self.chosen |= 1 << i;
            }
        }
    }

    fn winner(&self) -> bool {
        for i in 0..N_ROWS {
            let win_mask = ROW_WIN << (i * N_COLS);
            if (win_mask & self.chosen) == win_mask {
                return true;
            }
        }
        for i in 0..N_COLS {
            let win_mask = COL_WIN << i;
            if (win_mask & self.chosen) == win_mask {
                return true;
            }
        }
        false
    }

    fn sum_unmarked(&self) -> u32 {
        let mut sum = 0;
        for (i, &x) in self.squares.iter().enumerate() {
            if ((1 << i) & self.chosen) == 0 {
                sum += x;
            }
        }
        sum
    }
}

fn main() {
    let input = include_str!("../input.txt");
    let groups: Vec<_> = input.split("\n\n").collect();

    let nums: Vec<u32> = groups[0]
        .trim()
        .split(',')
        .map(|s| s.parse::<u32>().unwrap())
        .collect();

    let mut boards: Vec<Board> = groups[1..]
        .iter()
        .map(|g| {
            g.split_whitespace()
                .map(|s| s.parse::<u32>().unwrap())
                .collect::<Vec<_>>()
        })
        .map(|b| Board::new(&b))
        .collect();

    let mut scores = Vec::new();

    for n in nums {
        for b in &mut boards {
            if !b.winner() {
                b.set(n);
                if b.winner() {
                    scores.push(b.sum_unmarked() * n);
                }
            }
        }
    }

    println!("{}", scores.first().unwrap());
    println!("{}", scores.last().unwrap());
}

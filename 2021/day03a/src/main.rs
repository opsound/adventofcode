fn main() {
    let input = include_str!("../input.txt")
        .split_whitespace()
        .collect::<Vec<_>>();

    let n_bits = input[0].len();
    let mut occurrences = vec![0; n_bits];

    let nums = input
        .iter()
        .map(|s| u32::from_str_radix(s, 2).unwrap())
        .collect::<Vec<_>>();
    let n_nums = nums.len();

    for x in &nums {
        for i in 0..n_bits {
            if ((1 << i) & x) != 0 {
                occurrences[i] += 1;
            }
        }
    }

    let mut gamma = 0;
    let mut epsilon = 0;

    for (i, &x) in occurrences.iter().enumerate() {
        if x > n_nums / 2 {
            gamma |= 1 << i;
        } else {
            epsilon |= 1 << i;
        }
    }

    println!("{}", gamma * epsilon);
}

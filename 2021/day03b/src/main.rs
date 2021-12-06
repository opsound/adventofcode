use itertools::partition;

fn filter_most_common(nums: &mut [u32], bit_pos: usize) -> u32 {
    if nums.len() == 1 {
        return nums[0];
    }

    let idx = partition(&mut nums[..], |x| ((1 << bit_pos) & x) == 0);
    let zeros = idx;
    let ones = nums.len() - zeros;

    if ones >= zeros {
        filter_most_common(&mut nums[idx..], bit_pos - 1)
    } else {
        filter_most_common(&mut nums[..idx], bit_pos - 1)
    }
}

fn filter_least_common(nums: &mut [u32], bit_pos: usize) -> u32 {
    if nums.len() == 1 {
        return nums[0];
    }

    let idx = partition(&mut nums[..], |x| ((1 << bit_pos) & x) == 0);
    let zeros = idx;
    let ones = nums.len() - zeros;

    if zeros <= ones {
        filter_least_common(&mut nums[..idx], bit_pos - 1)
    } else {
        filter_least_common(&mut nums[idx..], bit_pos - 1)
    }
}

fn main() {
    let input = include_str!("../input.txt")
        .split_whitespace()
        .collect::<Vec<_>>();

    let n_bits = input[0].len();

    let mut nums = input
        .iter()
        .map(|s| u32::from_str_radix(s, 2).unwrap())
        .collect::<Vec<_>>();

    let o2 = filter_most_common(&mut nums, n_bits - 1);
    let co2 = filter_least_common(&mut nums, n_bits - 1);

    println!("{}", o2 * co2);
}

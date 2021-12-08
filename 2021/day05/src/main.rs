#[derive(Debug, Copy, Clone)]
struct Line {
    pt1: Pt,
    pt2: Pt,
}

#[derive(Debug, Copy, Clone)]
struct Pt {
    x: i32,
    y: i32,
}

fn pt_from_str(s: &str) -> Pt {
    let mut coords = s.trim().split(',').map(|s| s.parse::<i32>().unwrap());
    let x = coords.next().unwrap();
    let y = coords.next().unwrap();
    Pt { x, y }
}

fn main() {
    let lines = include_str!("../input.txt")
        .lines()
        .map(|l| {
            let mut parts = l.split("->");
            let pt1 = pt_from_str(parts.next().unwrap());
            let pt2 = pt_from_str(parts.next().unwrap());
            Line { pt1, pt2 }
        })
        .collect::<Vec<_>>();

    let space_width = lines
        .iter()
        .map(|l| [l.pt1, l.pt2])
        .flatten()
        .map(|pt| pt.x.max(pt.y))
        .max()
        .unwrap() as usize;

    let mut space = vec![vec![0; space_width + 1]; space_width + 1];

    for Line { pt1, pt2 } in &lines {
        if pt1.x == pt2.x {
            let a = pt1.y.min(pt2.y);
            let b = pt1.y.max(pt2.y);
            for y in a..=b {
                space[pt1.x as usize][y as usize] += 1;
            }
        } else if pt1.y == pt2.y {
            let a = pt1.x.min(pt2.x);
            let b = pt1.x.max(pt2.x);
            for x in a..=b {
                space[x as usize][pt1.y as usize] += 1;
            }
        }
    }

    let n_overlap = space.iter().flatten().filter(|&&v| v >= 2).count();
    println!("{}", n_overlap);

    for Line { pt1, pt2 } in &lines {
        let rise = pt2.y - pt1.y;
        let run = pt2.x - pt1.x;
        if rise.abs() == run.abs() {
            let xdir = if run > 0 { 1 } else { -1 };
            let ydir = if rise > 0 { 1 } else { -1 };
            for i in 0..=run.abs() {
                let x = pt1.x + i * xdir;
                let y = pt1.y + i * ydir;
                space[x as usize][y as usize] += 1;
            }
        }
    }

    let n_overlap = space.iter().flatten().filter(|&&v| v >= 2).count();
    println!("{}", n_overlap);
}

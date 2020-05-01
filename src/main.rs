use std::{env, fs};

fn main() {
    for entry in fs::read_dir("/").unwrap() {
        println!("in root: {:?}", entry);
    }
    println!("current: {:?}", env::current_dir().unwrap());
    loop {}
}

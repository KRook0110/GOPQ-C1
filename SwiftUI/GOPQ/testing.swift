enum Token: Equatable {
    case left(String)
    case right(Int)

    static func == (lhs: Token, rhs: Token) -> Bool {
        switch (lhs, rhs) {
        case (.left, .left),
            (.right, .right):
            return true
        default:
            return false
        }

    }
}

func main() {
    let x: Token = .left("")
    let y: Token = .left("Anjay")
    let a: Token = .right(0)

    if x == y {
        print("Yes")
    } else {
        print("NO")
    }

    if a == x {
        print("Si")
    } else {
        print("Not Si")
    }
}

main()

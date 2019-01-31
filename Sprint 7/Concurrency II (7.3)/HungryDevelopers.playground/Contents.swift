import Cocoa
import Foundation

// Create a class called Spoon. It should have two methods, pickUp() and putDown().
class Spoon {
    // You can implement this with a private lock property.
    private let lock = NSLock()
    let index: Int
    init(index: Int) {
        self.index = index
    }
    
    func pickUp(){
        lock.lock()
    }
    
    func putDown(){
        lock.unlock()
    }
}

// Create a class called Developer.
class Developer {
    var identifier: String = "Developer"
    
    // Each Developer should have a leftSpoon property and a rightSpoon property
    var leftSpoon: Spoon?
    var rightSpoon: Spoon?
    
//    init(leftSpoon: Spoon, rightSpoon: Spoon){
//        self.leftSpoon = leftSpoon
//        self.rightSpoon = rightSpoon
//    }

    // It should also have think() , eat() , and run() methods.
    // think() should pick up both spoons before returning.
    func think(){
        if leftSpoon!.index < rightSpoon!.index {
            print("\(self.identifier) is thinking.")
            rightSpoon?.pickUp()
            print("\(self.identifier) picked up right spoon.")
            leftSpoon?.pickUp()
            print("\(self.identifier) picked up left spoon.")
        } else {
            rightSpoon?.pickUp()
            print("\(self.identifier) picked up right spoon.")
            leftSpoon?.pickUp()
            print("\(self.identifier) picked up left spoon.")
        }
    }
    
    // eat() should pause for a random amount of time before putting both
    // spoons down. (Hint: use usleep() to pause for a given number of microseconds).
    func eat() {
        let startTime = Date()
        usleep(UInt32.random(in: 100_000_0 ... 2_000_000))
        let endTime = Date()
        
        
        // usleep(useconds_t(Int.random(in: 1 ... 1000)))
        print("\(self.identifier) is eating.")
        let elapsedTime = endTime.timeIntervalSinceReferenceDate -
            startTime.timeIntervalSinceReferenceDate
        print("\(self.identifier) ate for: \(elapsedTime)")
        leftSpoon?.putDown()
        print("\(self.identifier) put down right spoon.")
        rightSpoon?.putDown()
        print("\(self.identifier) put down left spoon.")
    }
    

    // Developer.run() should call think() then
    // eat() over and over again forever.
    func run() {
        while true {
            think()
            eat()
        }
    }
}

// Create 5 Spoon s and 5 Developer s giving each developer a left and right spoon.
// Note that developers will of course share spoons. Ever developer's right spoon is
// the next developer's left spoon.

var developers: [Developer] = []
var spoons: [Spoon] = []


func createDeveloper(numberOfDevs: Int) {
    for index in 1 ... numberOfDevs {
        let developer = Developer()
        let spoon = Spoon(index: index)
        developers.append(developer)
        spoons.append(spoon)
        developers[index - 1].leftSpoon = spoons[index - 1]
        developers[index - 1].identifier += "\(index)"
    }
    
    for index in 1 ... numberOfDevs {
        if index == developers.count {
            developers[index - 1].rightSpoon = spoons[0]
        } else {
            developers[index - 1].rightSpoon = spoons[index]
        }
    }
}

createDeveloper(numberOfDevs: 5)
for developer in developers {
    print (developer.identifier)
}


// ??? Developer5 never gets called. I guess I don't undestand
// what I'm doing... Sad Panda... ???//
DispatchQueue.concurrentPerform(iterations: 5) {
    developers[$0].run()
}

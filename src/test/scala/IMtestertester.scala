// package single_cycle

// import chisel3._
//  import chisel3.tester._
//  import org.scalatest.FreeSpec
//  import chisel3.experimental.BundleLiterals._

//  class IMtester extends FreeSpec with ChiselScalatestTester{
//     "im tester file"in{
//         test(new InstMem("C:/Users/Saffy Yawar/Scala-Chisel-Learning-Journey/src/main/scala/gcd/inMem.txt")) {a =>
//         a.io.addr.poke(4.U)
//         a.clock.step(1)
//         a.io.inst.expect(0X00300113.U)
//         }
//     }
// }


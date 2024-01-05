// package single_cycle

//  import chisel3._
//  import chisel3.tester._
//  import org.scalatest.FreeSpec
//  import chisel3.experimental.BundleLiterals._

//  class Registerfile extends FreeSpec with ChiselScalatestTester{
//     "reg tester file"in{
//         test(new  register) {a =>
//             a.io.ren.poke(1.B)
//                 a.io.data.poke(10.U)
//                     a.io.rs1.poke(2.U)
//                         a.io.rs2.poke(2.U)
//                             a.io.rd.poke(2.U)
//                                 a.clock.step(1)
//                                     a.io.rs1out.expect(0.U)
//                                           a.io.rs2out.expect(0.U)
                                        
//                                           a.clock.step()
//         }
//     }
// }


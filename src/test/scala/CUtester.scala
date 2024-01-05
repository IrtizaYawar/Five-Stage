// package single_cycle

// import chisel3._
//  import chisel3.tester._
//  import org.scalatest.FreeSpec
//  import chisel3.experimental.BundleLiterals._

 
//  class controlunittester extends FreeSpec with ChiselScalatestTester{
//     "CU tester file"in{
//         test(new controlunit) { a => 
//             a.io.in.poke(0x00200093.U)
//             a.clock.step()
//             a.io.aluop.expect(0.B)
//               a.io.format.expect(0.B)
//                   a.io.rd.expect(1.U)
//                   a.io.rs1.expect(0.U)
//                   a.io.rs2.expect(0.U)
//                   a.io.imm.expect(2.U)
                  
//         }
//     }
// }


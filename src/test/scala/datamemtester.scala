// package single_cycle

// import chisel3._
// import chisel3.tester._
// import org.scalatest.FreeSpec
// import chisel3.experimental.BundleLiterals._

// class DatamemTester extends FreeSpec with ChiselScalatestTester {
//   "dmem tester" in {
//     test(new Datamem) { a =>
//       a.io.addr.poke(0.U)
//       a.io.Din.poke(8.U)
//       a.io.fun3.poke(0.U)
//       a.clock.step(1)
//       a.io.Dout.expect(1.U)
//     }
//   }
// }

package single_cycle

import chisel3._
 import chisel3.tester._
 import org.scalatest.FreeSpec
 import chisel3.experimental.BundleLiterals._

 
 class toptester extends FreeSpec with ChiselScalatestTester{
    "toptop tester file"in{
        test(new top) { a => 
            a.clock.step(200)
            a.io.out.expect(0.U)
        }
    }
 }
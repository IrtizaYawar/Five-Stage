package single_cycle

import chisel3._
 import chisel3.tester._
 import org.scalatest.FreeSpec
 import chisel3.experimental.BundleLiterals._

 
 class Datapathtester extends FreeSpec with ChiselScalatestTester{
    "Datapath tester file"in{
        test(new Datapath) { a => 
            a.clock.step(200)
            a.io.out.expect(0.U)
        }
    }
}
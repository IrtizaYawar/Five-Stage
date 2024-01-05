package single_cycle

import chisel3._
import chisel3.util._
class Datamem extends Module {
    val io = IO(new Bundle {
    val Wr_en = Input(Bool())
    val address = Input(UInt(32.W))
    val datain = Input(UInt(32.W))
    val Dout = Output(UInt(32.W))
    //val Dout = Output(UInt(32.W))
    val fun3 = Input(UInt(3.W))
    //val mask = Input(Vec(4,Bool()))
  })

  val memory = Mem (1024 ,Vec (4 , UInt ( 8 . W ) ) )
  val mask = Wire(Vec(4,Bool()))
  val data = Wire(Vec(4,UInt(8.W)))
  val temp = Wire(Vec (4,UInt(8.W)))

  io.Dout := 0.U

  mask(0) := 0.B
  mask(1) := 0.B
  mask(2) := 0.B
  mask(3) := 0.B
  
  data(0) := io.datain(7,0)
  data(1) := io.datain(15,8)
  data(2) := io.datain(23,16)
  data(3) := io.datain(31,24)

when(io.Wr_en){
  when(io.fun3 === 0.U){   //SB
    when(io.address(1,0)=== 0.U){



      mask(0) := 1.B
      // mask(1) := 0.B
      // mask(2) := 0.B
      // mask(3) := 0.B

      data(0) := io.datain(7,0)
    }
    .elsewhen(io.address(1,0) === 1.U){


      // mask(0) := 0.B
      mask(1) := 1.B
      mask(2) := 0.B
      mask(3) := 0.B

      data(1) := io.datain(7,0)

      
    }
    .elsewhen(io.address(1,0) === 2.U){

      // mask(0) := 0.B
      // mask(1) := 0.B
      mask(2) := 1.B
      // mask(3) := 0.B

      data(2) := io.datain(7,0)
    }
     .elsewhen(io.address(1,0) === 3.U){  

      // mask(0) := 0.B
      // mask(1) := 0.B
      // mask(2) := 0.B
      mask(3) := 1.B

      data(3) := io.datain(7,0)

    }
  
  .elsewhen(io.fun3 === 1.U){//SH

     when(io.address(1, 0) === 0.U) {
      mask(0) := 1.B
      mask(1) := 1.B
      // mask(2) := 0.B
      // mask(3) := 0.B

      data(0) := io.datain(7,0)
      data(1) := io.datain(15,8)
    }.elsewhen(io.address(1, 0) === 1.U) {

      // mask(0) := 0.B
      mask(1) := 1.B
      // mask(2) := 1.B
      mask(3) := 0.B

      data(1) := io.datain(7,0)
      data(2) := io.datain(15,8)
    }
    .elsewhen( io.address(1, 0) === 2.U) {

      // mask(0) := 0.B
      // mask(1) := 0.B
      mask(2) := 1.B
      mask(3) := 1.B

      data(2) :=io.datain(7,0)
      data(3) := io.datain(15,8)
    }
    .elsewhen( io.address(1, 0) === 3.U) {

      mask(0) := 1.B
      // mask(1) := 0.B
      // mask(2) := 0.B
      mask(3) := 1.B

      data(3) :=io.datain(7,0)
      data(0) := io.datain(15,8)
    }

   }
   .elsewhen(io.fun3 === 2.U){//SW

    //  when(io.address(1, 0) === 0.U) {
  

      mask(0) := 1.B
      mask(1) := 1.B
      mask(2) := 1.B
      mask(3) := 1.B

  data(0) := io.datain(7,0)
  data(1) := io.datain(15,8)
  data(2) := io.datain(23,16)
  data(3) := io.datain(31,24)
    // }
    
  }
}
// val wr_address = io.address()
  memory.write(io.address(31,2),data, mask)
   temp:=memory.read(io.address(31,2))
  }

temp:= memory.read(io.address(31,2))

when(io.fun3 === 0.U) {//LB
    when(io.address(1,0) === 0.U){
    io.Dout := Cat(Fill(24,temp(0)(7)),temp(0))}
    .elsewhen(io.address(1,0)=== 1.U){
    io.Dout := Cat(Fill(24,temp(1)(7)),temp(1))}
    .elsewhen(io.address(1,0)=== 2.U){
    io.Dout := Cat(Fill(24,temp(2)(7)),temp(2))}
    .elsewhen(io.address(1,0)=== 3.U){
    io.Dout := Cat(Fill(24,temp(3)(7)),temp(3))}

  }.elsewhen(io.fun3 === 1.U) {//LH
    when(io.address(1,0) === 0.U){
    io.Dout := Cat(Fill(16,temp(0)(7)),temp(0),temp(1))}
    .elsewhen(io.address(1,0)=== 1.U){
    io.Dout := Cat(Fill(16,temp(1)(7)),temp(1),temp(2))}
    .elsewhen(io.address(1,0)=== 2.U){
    io.Dout := Cat(Fill(16,temp(2)(7)),temp(2),temp(3))}
    .elsewhen(io.address(1,0)=== 3.U){
    io.Dout := Cat(Fill(24,temp(3)(7)),temp(3))}
  }.elsewhen(io.fun3 === 2.U) { //lW
    io.Dout := Cat(temp(3), temp(2), temp(1), temp(0))
}
}


 
  

circuit top :
  module Pc :
    input clock : Clock
    input reset : UInt<1>
    output io_addressout : UInt<32>

    reg counter : UInt<32>, clock with :
      reset => (UInt<1>("h0"), counter) @[Pc.scala 10:26]
    node _counter_T = add(counter, UInt<3>("h4")) @[Pc.scala 11:25]
    node _counter_T_1 = tail(_counter_T, 1) @[Pc.scala 11:25]
    node _counter_T_2 = div(_counter_T_1, UInt<3>("h4")) @[Pc.scala 11:30]
    io_addressout <= counter @[Pc.scala 12:18]
    counter <= mux(reset, UInt<32>("h0"), _counter_T_2) @[Pc.scala 10:26 Pc.scala 10:26 Pc.scala 11:13]

  module InstMem :
    input clock : Clock
    input reset : UInt<1>
    input io_addr : UInt<32>
    output io_inst : UInt<32>

    mem imem : @[IM.scala 15:16]
      data-type => UInt<32>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => io_inst_MPORT
      read-under-write => undefined
    node _io_inst_T = div(io_addr, UInt<3>("h4")) @[IM.scala 17:31]
    node _io_inst_T_1 = bits(_io_inst_T, 9, 0) @[IM.scala 17:19]
    io_inst <= imem.io_inst_MPORT.data @[IM.scala 17:11]
    imem.io_inst_MPORT.addr <= _io_inst_T_1 @[IM.scala 17:19]
    imem.io_inst_MPORT.en <= UInt<1>("h1") @[IM.scala 17:19]
    imem.io_inst_MPORT.clk <= clock @[IM.scala 17:19]

  module register :
    input clock : Clock
    input reset : UInt<1>
    input io_ren : UInt<1>
    input io_data : UInt<32>
    input io_rs1 : UInt<5>
    input io_rs2 : UInt<5>
    input io_rd : UInt<5>
    output io_rs1out : UInt<32>
    output io_rs2out : UInt<32>

    mem registerfile : @[registerfile1.scala 20:24]
      data-type => UInt<32>
      depth => 32
      read-latency => 0
      write-latency => 1
      reader => io_rs1out_MPORT
      reader => io_rs2out_MPORT
      reader => io_rs1out_MPORT_1
      reader => io_rs2out_MPORT_1
      writer => MPORT
      read-under-write => undefined
    node _T = neq(io_rd, UInt<1>("h0")) @[registerfile1.scala 21:22]
    node _T_1 = and(io_ren, _T) @[registerfile1.scala 21:13]
    node _GEN_0 = validif(_T_1, io_rd) @[registerfile1.scala 21:30 registerfile1.scala 22:17]
    node _GEN_1 = validif(_T_1, clock) @[registerfile1.scala 21:30 registerfile1.scala 22:17]
    node _GEN_2 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[registerfile1.scala 21:30 registerfile1.scala 22:17 registerfile1.scala 20:24]
    node _GEN_3 = validif(_T_1, UInt<1>("h1")) @[registerfile1.scala 21:30 registerfile1.scala 22:25]
    node _GEN_4 = validif(_T_1, io_data) @[registerfile1.scala 21:30 registerfile1.scala 22:25]
    node _GEN_5 = validif(_T_1, io_rs1) @[registerfile1.scala 21:30 registerfile1.scala 23:30]
    node _GEN_6 = mux(_T_1, registerfile.io_rs1out_MPORT.data, registerfile.io_rs1out_MPORT_1.data) @[registerfile1.scala 21:30 registerfile1.scala 23:15 registerfile1.scala 26:15]
    node _GEN_7 = validif(_T_1, io_rs2) @[registerfile1.scala 21:30 registerfile1.scala 24:30]
    node _GEN_8 = mux(_T_1, registerfile.io_rs2out_MPORT.data, registerfile.io_rs2out_MPORT_1.data) @[registerfile1.scala 21:30 registerfile1.scala 24:15 registerfile1.scala 27:15]
    node _GEN_9 = validif(eq(_T_1, UInt<1>("h0")), io_rs1) @[registerfile1.scala 21:30 registerfile1.scala 26:30]
    node _GEN_10 = validif(eq(_T_1, UInt<1>("h0")), clock) @[registerfile1.scala 21:30 registerfile1.scala 26:30]
    node _GEN_11 = mux(_T_1, UInt<1>("h0"), UInt<1>("h1")) @[registerfile1.scala 21:30 registerfile1.scala 20:24 registerfile1.scala 26:30]
    node _GEN_12 = validif(eq(_T_1, UInt<1>("h0")), io_rs2) @[registerfile1.scala 21:30 registerfile1.scala 27:30]
    io_rs1out <= _GEN_6
    io_rs2out <= _GEN_8
    registerfile.io_rs1out_MPORT.addr <= _GEN_5
    registerfile.io_rs1out_MPORT.en <= _GEN_2
    registerfile.io_rs1out_MPORT.clk <= _GEN_1
    registerfile.io_rs2out_MPORT.addr <= _GEN_7
    registerfile.io_rs2out_MPORT.en <= _GEN_2
    registerfile.io_rs2out_MPORT.clk <= _GEN_1
    registerfile.io_rs1out_MPORT_1.addr <= _GEN_9
    registerfile.io_rs1out_MPORT_1.en <= _GEN_11
    registerfile.io_rs1out_MPORT_1.clk <= _GEN_10
    registerfile.io_rs2out_MPORT_1.addr <= _GEN_12
    registerfile.io_rs2out_MPORT_1.en <= _GEN_11
    registerfile.io_rs2out_MPORT_1.clk <= _GEN_10
    registerfile.MPORT.addr <= _GEN_0
    registerfile.MPORT.en <= _GEN_2
    registerfile.MPORT.clk <= _GEN_1
    registerfile.MPORT.data <= _GEN_4
    registerfile.MPORT.mask <= _GEN_3

  module controlunit :
    input clock : Clock
    input reset : UInt<1>
    input io_in : UInt<32>
    output io_Opcode : UInt<7>
    output io_aluop : UInt<4>
    output io_iformat : UInt<1>
    output io_rformat : UInt<1>
    output io_sformat : UInt<1>
    output io_bformat : UInt<1>
    output io_jalformate : UInt<1>
    output io_luiformate : UInt<1>
    output io_Auipcformate : UInt<1>
    output io_jalrformate : UInt<1>
    output io_rd : UInt<5>
    output io_fun_3 : UInt<3>
    output io_rs1 : UInt<5>
    output io_rs2 : UInt<5>
    output io_imm : UInt<32>
    output io_mem_wr_en : UInt<1>
    output io_Wr_en : UInt<1>
    output io_Wr_back : UInt<2>
    output io_bran_fn3 : UInt<3>
    input io_btake : UInt<1>
    output io_pcsel : UInt<1>

    node _io_Opcode_T = bits(io_in, 6, 0) @[CU.scala 36:28]
    node f3 = bits(io_in, 14, 12) @[CU.scala 46:23]
    node f7 = bits(io_in, 31, 25) @[CU.scala 47:23]
    node _T = eq(io_Opcode, UInt<6>("h33")) @[CU.scala 61:21]
    node _io_rd_T = bits(io_in, 11, 7) @[CU.scala 65:24]
    node io_aluop_lo = bits(f7, 5, 5) @[CU.scala 66:30]
    node _io_aluop_T = cat(f3, io_aluop_lo) @[Cat.scala 30:58]
    node _io_rs1_T = bits(io_in, 19, 15) @[CU.scala 67:25]
    node _io_rs2_T = bits(io_in, 24, 20) @[CU.scala 68:26]
    node _T_1 = eq(io_Opcode, UInt<5>("h13")) @[CU.scala 71:25]
    node _io_rd_T_1 = bits(io_in, 11, 7) @[CU.scala 75:24]
    node _io_aluop_T_1 = cat(f3, UInt<1>("h0")) @[Cat.scala 30:58]
    node _T_2 = eq(f3, UInt<3>("h5")) @[CU.scala 77:16]
    node _T_3 = eq(f3, UInt<1>("h1")) @[CU.scala 77:26]
    node _T_4 = or(_T_2, _T_3) @[CU.scala 77:22]
    node io_aluop_lo_1 = bits(f7, 5, 5) @[CU.scala 78:34]
    node _io_aluop_T_2 = cat(f3, io_aluop_lo_1) @[Cat.scala 30:58]
    node _io_aluop_T_3 = cat(f3, UInt<1>("h0")) @[Cat.scala 30:58]
    node _GEN_0 = mux(_T_4, _io_aluop_T_2, _io_aluop_T_3) @[CU.scala 77:33 CU.scala 78:23 CU.scala 81:23]
    node _io_rs1_T_1 = bits(io_in, 19, 15) @[CU.scala 83:25]
    node _io_imm_T = bits(io_in, 31, 31) @[CU.scala 86:40]
    node _io_imm_T_1 = bits(_io_imm_T, 0, 0) @[Bitwise.scala 72:15]
    node io_imm_hi = mux(_io_imm_T_1, UInt<19>("h7ffff"), UInt<19>("h0")) @[Bitwise.scala 72:12]
    node io_imm_lo = bits(io_in, 31, 20) @[CU.scala 86:51]
    node _io_imm_T_2 = cat(io_imm_hi, io_imm_lo) @[Cat.scala 30:58]
    node _T_5 = eq(io_Opcode, UInt<2>("h3")) @[CU.scala 89:25]
    node _io_rd_T_2 = bits(io_in, 11, 7) @[CU.scala 92:19]
    node _io_rs1_T_2 = bits(io_in, 20, 15) @[CU.scala 93:20]
    node _io_imm_T_3 = bits(io_in, 31, 31) @[CU.scala 100:33]
    node _io_imm_T_4 = bits(_io_imm_T_3, 0, 0) @[Bitwise.scala 72:15]
    node io_imm_hi_1 = mux(_io_imm_T_4, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node io_imm_lo_1 = bits(io_in, 31, 20) @[CU.scala 100:44]
    node _io_imm_T_5 = cat(io_imm_hi_1, io_imm_lo_1) @[Cat.scala 30:58]
    node _T_6 = eq(io_Opcode, UInt<6>("h23")) @[CU.scala 103:24]
    node _io_rs1_T_3 = bits(io_in, 19, 15) @[CU.scala 106:19]
    node _io_rs2_T_1 = bits(io_in, 24, 20) @[CU.scala 107:20]
    node _io_imm_T_6 = bits(io_in, 31, 31) @[CU.scala 109:35]
    node _io_imm_T_7 = bits(_io_imm_T_6, 0, 0) @[Bitwise.scala 72:15]
    node io_imm_hi_hi = mux(_io_imm_T_7, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node io_imm_hi_lo = bits(io_in, 31, 25) @[CU.scala 109:46]
    node io_imm_lo_2 = bits(io_in, 11, 7) @[CU.scala 109:59]
    node io_imm_hi_2 = cat(io_imm_hi_hi, io_imm_hi_lo) @[Cat.scala 30:58]
    node _io_imm_T_8 = cat(io_imm_hi_2, io_imm_lo_2) @[Cat.scala 30:58]
    node _T_7 = eq(io_Opcode, UInt<7>("h63")) @[CU.scala 116:21]
    node _io_rs1_T_4 = bits(io_in, 19, 15) @[CU.scala 118:19]
    node _io_rs2_T_2 = bits(io_in, 24, 20) @[CU.scala 119:19]
    node _io_imm_T_9 = bits(io_in, 31, 31) @[CU.scala 120:32]
    node _io_imm_T_10 = bits(_io_imm_T_9, 0, 0) @[Bitwise.scala 72:15]
    node io_imm_hi_hi_hi = mux(_io_imm_T_10, UInt<19>("h7ffff"), UInt<19>("h0")) @[Bitwise.scala 72:12]
    node io_imm_hi_hi_lo = bits(io_in, 31, 31) @[CU.scala 120:43]
    node io_imm_hi_lo_1 = bits(io_in, 7, 7) @[CU.scala 120:53]
    node io_imm_lo_hi_hi = bits(io_in, 30, 25) @[CU.scala 120:62]
    node io_imm_lo_hi_lo = bits(io_in, 11, 8) @[CU.scala 120:75]
    node io_imm_lo_hi = cat(io_imm_lo_hi_hi, io_imm_lo_hi_lo) @[Cat.scala 30:58]
    node io_imm_lo_3 = cat(io_imm_lo_hi, UInt<1>("h0")) @[Cat.scala 30:58]
    node io_imm_hi_hi_1 = cat(io_imm_hi_hi_hi, io_imm_hi_hi_lo) @[Cat.scala 30:58]
    node io_imm_hi_3 = cat(io_imm_hi_hi_1, io_imm_hi_lo_1) @[Cat.scala 30:58]
    node _io_imm_T_11 = cat(io_imm_hi_3, io_imm_lo_3) @[Cat.scala 30:58]
    node _io_bran_fn3_T = bits(io_in, 14, 12) @[CU.scala 125:24]
    node _GEN_1 = mux(io_btake, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 127:19 CU.scala 128:13 CU.scala 51:17]
    node _T_8 = eq(io_Opcode, UInt<7>("h6f")) @[CU.scala 132:22]
    node _io_rd_T_3 = bits(io_in, 11, 7) @[CU.scala 134:18]
    node _io_imm_T_12 = bits(io_in, 31, 31) @[CU.scala 141:34]
    node _io_imm_T_13 = bits(_io_imm_T_12, 0, 0) @[Bitwise.scala 72:15]
    node io_imm_hi_hi_hi_1 = mux(_io_imm_T_13, UInt<11>("h7ff"), UInt<11>("h0")) @[Bitwise.scala 72:12]
    node io_imm_hi_hi_lo_1 = bits(io_in, 31, 31) @[CU.scala 141:45]
    node io_imm_hi_lo_2 = bits(io_in, 19, 12) @[CU.scala 141:55]
    node io_imm_lo_hi_hi_1 = bits(io_in, 20, 20) @[CU.scala 141:68]
    node io_imm_lo_hi_lo_1 = bits(io_in, 30, 21) @[CU.scala 141:78]
    node io_imm_lo_hi_1 = cat(io_imm_lo_hi_hi_1, io_imm_lo_hi_lo_1) @[Cat.scala 30:58]
    node io_imm_lo_4 = cat(io_imm_lo_hi_1, UInt<1>("h0")) @[Cat.scala 30:58]
    node io_imm_hi_hi_2 = cat(io_imm_hi_hi_hi_1, io_imm_hi_hi_lo_1) @[Cat.scala 30:58]
    node io_imm_hi_4 = cat(io_imm_hi_hi_2, io_imm_hi_lo_2) @[Cat.scala 30:58]
    node _io_imm_T_14 = cat(io_imm_hi_4, io_imm_lo_4) @[Cat.scala 30:58]
    node _T_9 = eq(io_Opcode, UInt<6>("h37")) @[CU.scala 146:23]
    node _io_rd_T_4 = bits(io_in, 11, 7) @[CU.scala 148:19]
    node io_imm_hi_5 = bits(io_in, 31, 12) @[CU.scala 155:24]
    node io_imm_lo_5 = mux(UInt<1>("h0"), UInt<12>("hfff"), UInt<12>("h0")) @[Bitwise.scala 72:12]
    node _io_imm_T_15 = cat(io_imm_hi_5, io_imm_lo_5) @[Cat.scala 30:58]
    node _T_10 = eq(io_Opcode, UInt<7>("h67")) @[CU.scala 160:22]
    node _io_rd_T_5 = bits(io_in, 11, 7) @[CU.scala 162:19]
    node _io_rs1_T_5 = bits(io_in, 19, 15) @[CU.scala 163:20]
    node _io_imm_T_16 = bits(io_in, 31, 31) @[CU.scala 170:31]
    node _io_imm_T_17 = bits(_io_imm_T_16, 0, 0) @[Bitwise.scala 72:15]
    node io_imm_hi_6 = mux(_io_imm_T_17, UInt<11>("h7ff"), UInt<11>("h0")) @[Bitwise.scala 72:12]
    node io_imm_lo_6 = bits(io_in, 31, 20) @[CU.scala 170:42]
    node _io_imm_T_18 = cat(io_imm_hi_6, io_imm_lo_6) @[Cat.scala 30:58]
    node _T_11 = eq(io_Opcode, UInt<7>("h67")) @[CU.scala 173:23]
    node io_imm_hi_7 = bits(io_in, 31, 12) @[CU.scala 182:24]
    node io_imm_lo_7 = mux(UInt<1>("h0"), UInt<12>("hfff"), UInt<12>("h0")) @[Bitwise.scala 72:12]
    node _io_imm_T_19 = cat(io_imm_hi_7, io_imm_lo_7) @[Cat.scala 30:58]
    node _GEN_2 = mux(_T_11, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 173:40 CU.scala 174:20 CU.scala 192:24]
    node _GEN_3 = mux(_T_11, UInt<1>("h0"), UInt<1>("h0")) @[CU.scala 173:40 CU.scala 175:10 CU.scala 43:15]
    node _GEN_4 = mux(_T_11, _io_imm_T_19, UInt<1>("h0")) @[CU.scala 173:40 CU.scala 182:12 CU.scala 195:15]
    node _GEN_5 = mux(_T_10, UInt<1>("h1"), _GEN_3) @[CU.scala 160:39 CU.scala 161:19]
    node _GEN_6 = mux(_T_10, _io_rd_T_5, _GEN_3) @[CU.scala 160:39 CU.scala 162:11]
    node _GEN_7 = mux(_T_10, _io_rs1_T_5, _GEN_3) @[CU.scala 160:39 CU.scala 163:12]
    node _GEN_8 = mux(_T_10, UInt<1>("h0"), _GEN_3) @[CU.scala 160:39 CU.scala 164:12]
    node _GEN_9 = mux(_T_10, UInt<2>("h2"), _GEN_3) @[CU.scala 160:39 CU.scala 167:16]
    node _GEN_10 = mux(_T_10, UInt<1>("h1"), _GEN_2) @[CU.scala 160:39 CU.scala 169:14]
    node _GEN_11 = mux(_T_10, _io_imm_T_18, _GEN_4) @[CU.scala 160:39 CU.scala 170:12]
    node _GEN_12 = mux(_T_10, UInt<1>("h0"), _GEN_2) @[CU.scala 160:39 CU.scala 56:24]
    node _GEN_13 = mux(_T_9, UInt<1>("h1"), _GEN_8) @[CU.scala 146:40 CU.scala 147:18]
    node _GEN_14 = mux(_T_9, _io_rd_T_4, _GEN_6) @[CU.scala 146:40 CU.scala 148:11]
    node _GEN_15 = mux(_T_9, UInt<1>("h0"), _GEN_7) @[CU.scala 146:40 CU.scala 149:12]
    node _GEN_16 = mux(_T_9, UInt<1>("h0"), _GEN_8) @[CU.scala 146:40 CU.scala 150:11]
    node _GEN_17 = mux(_T_9, UInt<1>("h1"), _GEN_5) @[CU.scala 146:40 CU.scala 152:13]
    node _GEN_18 = mux(_T_9, UInt<1>("h1"), _GEN_9) @[CU.scala 146:40 CU.scala 153:15]
    node _GEN_19 = mux(_T_9, UInt<1>("h0"), _GEN_10) @[CU.scala 146:40 CU.scala 154:13]
    node _GEN_20 = mux(_T_9, _io_imm_T_15, _GEN_11) @[CU.scala 146:40 CU.scala 155:12]
    node _GEN_21 = mux(_T_9, UInt<1>("h0"), _GEN_5) @[CU.scala 146:40 CU.scala 57:23]
    node _GEN_22 = mux(_T_9, UInt<1>("h0"), _GEN_12) @[CU.scala 146:40 CU.scala 56:24]
    node _GEN_23 = mux(_T_8, UInt<1>("h1"), _GEN_16) @[CU.scala 132:39 CU.scala 143:18]
    node _GEN_24 = mux(_T_8, _io_rd_T_3, _GEN_14) @[CU.scala 132:39 CU.scala 134:10]
    node _GEN_25 = mux(_T_8, UInt<1>("h0"), _GEN_15) @[CU.scala 132:39 CU.scala 135:11]
    node _GEN_26 = mux(_T_8, UInt<1>("h0"), _GEN_16) @[CU.scala 132:39 CU.scala 136:11]
    node _GEN_27 = mux(_T_8, UInt<2>("h2"), _GEN_18) @[CU.scala 132:39 CU.scala 138:15]
    node _GEN_28 = mux(_T_8, UInt<1>("h1"), _GEN_17) @[CU.scala 132:39 CU.scala 139:13]
    node _GEN_29 = mux(_T_8, UInt<1>("h1"), _GEN_19) @[CU.scala 132:39 CU.scala 140:13]
    node _GEN_30 = mux(_T_8, _io_imm_T_14, _GEN_20) @[CU.scala 132:39 CU.scala 141:12]
    node _GEN_31 = mux(_T_8, UInt<1>("h0"), _GEN_13) @[CU.scala 132:39 CU.scala 55:22]
    node _GEN_32 = mux(_T_8, UInt<1>("h0"), _GEN_21) @[CU.scala 132:39 CU.scala 57:23]
    node _GEN_33 = mux(_T_8, UInt<1>("h0"), _GEN_22) @[CU.scala 132:39 CU.scala 56:24]
    node _GEN_34 = mux(_T_7, UInt<1>("h1"), _GEN_26) @[CU.scala 116:38 CU.scala 117:15]
    node _GEN_35 = mux(_T_7, _io_rs1_T_4, _GEN_25) @[CU.scala 116:38 CU.scala 118:11]
    node _GEN_36 = mux(_T_7, _io_rs2_T_2, _GEN_26) @[CU.scala 116:38 CU.scala 119:11]
    node _GEN_37 = mux(_T_7, _io_imm_T_11, _GEN_30) @[CU.scala 116:38 CU.scala 120:12]
    node _GEN_38 = mux(_T_7, UInt<1>("h0"), _GEN_26) @[CU.scala 116:38 CU.scala 121:14]
    node _GEN_39 = mux(_T_7, UInt<1>("h0"), _GEN_27) @[CU.scala 116:38 CU.scala 122:16]
    node _GEN_40 = mux(_T_7, UInt<1>("h0"), _GEN_28) @[CU.scala 116:38 CU.scala 124:14]
    node _GEN_41 = mux(_T_7, _io_bran_fn3_T, UInt<1>("h0")) @[CU.scala 116:38 CU.scala 125:16 CU.scala 48:20]
    node _GEN_42 = mux(_T_7, UInt<1>("h0"), _GEN_24) @[CU.scala 116:38 CU.scala 126:10]
    node _GEN_43 = mux(_T_7, _GEN_1, _GEN_29) @[CU.scala 116:38]
    node _GEN_44 = mux(_T_7, UInt<1>("h0"), _GEN_23) @[CU.scala 116:38 CU.scala 54:22]
    node _GEN_45 = mux(_T_7, UInt<1>("h0"), _GEN_31) @[CU.scala 116:38 CU.scala 55:22]
    node _GEN_46 = mux(_T_7, UInt<1>("h0"), _GEN_32) @[CU.scala 116:38 CU.scala 57:23]
    node _GEN_47 = mux(_T_7, UInt<1>("h0"), _GEN_33) @[CU.scala 116:38 CU.scala 56:24]
    node _GEN_48 = mux(_T_6, UInt<1>("h0"), _GEN_40) @[CU.scala 103:41 CU.scala 104:13]
    node _GEN_49 = mux(_T_6, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 103:41 CU.scala 105:15 CU.scala 45:19]
    node _GEN_50 = mux(_T_6, _io_rs1_T_3, _GEN_35) @[CU.scala 103:41 CU.scala 106:11]
    node _GEN_51 = mux(_T_6, _io_rs2_T_1, _GEN_36) @[CU.scala 103:41 CU.scala 107:12]
    node _GEN_52 = mux(_T_6, f3, UInt<1>("h0")) @[CU.scala 103:41 CU.scala 108:14 CU.scala 44:17]
    node _GEN_53 = mux(_T_6, _io_imm_T_8, _GEN_37) @[CU.scala 103:41 CU.scala 109:15]
    node _GEN_54 = mux(_T_6, UInt<1>("h0"), _GEN_38) @[CU.scala 103:41 CU.scala 110:15]
    node _GEN_55 = mux(_T_6, UInt<1>("h1"), _GEN_38) @[CU.scala 103:41 CU.scala 111:19]
    node _GEN_56 = mux(_T_6, UInt<1>("h0"), _GEN_39) @[CU.scala 103:41 CU.scala 112:17]
    node _GEN_57 = mux(_T_6, UInt<1>("h0"), _GEN_41) @[CU.scala 103:41 CU.scala 113:18]
    node _GEN_58 = mux(_T_6, UInt<1>("h0"), _GEN_34) @[CU.scala 103:41 CU.scala 52:20]
    node _GEN_59 = mux(_T_6, UInt<1>("h0"), _GEN_42) @[CU.scala 103:41 CU.scala 43:15]
    node _GEN_60 = mux(_T_6, UInt<1>("h0"), _GEN_43) @[CU.scala 103:41 CU.scala 51:17]
    node _GEN_61 = mux(_T_6, UInt<1>("h0"), _GEN_44) @[CU.scala 103:41 CU.scala 54:22]
    node _GEN_62 = mux(_T_6, UInt<1>("h0"), _GEN_45) @[CU.scala 103:41 CU.scala 55:22]
    node _GEN_63 = mux(_T_6, UInt<1>("h0"), _GEN_46) @[CU.scala 103:41 CU.scala 57:23]
    node _GEN_64 = mux(_T_6, UInt<1>("h0"), _GEN_47) @[CU.scala 103:41 CU.scala 56:24]
    node _GEN_65 = mux(_T_5, UInt<1>("h1"), _GEN_48) @[CU.scala 89:42 CU.scala 91:14]
    node _GEN_66 = mux(_T_5, _io_rd_T_2, _GEN_59) @[CU.scala 89:42 CU.scala 92:11]
    node _GEN_67 = mux(_T_5, _io_rs1_T_2, _GEN_50) @[CU.scala 89:42 CU.scala 93:12]
    node _GEN_68 = mux(_T_5, UInt<1>("h0"), _GEN_54) @[CU.scala 89:42 CU.scala 94:14]
    node _GEN_69 = mux(_T_5, UInt<1>("h0"), _GEN_55) @[CU.scala 89:42 CU.scala 95:18]
    node _GEN_70 = mux(_T_5, UInt<1>("h0"), _GEN_56) @[CU.scala 89:42 CU.scala 96:16]
    node _GEN_71 = mux(_T_5, UInt<1>("h0"), _GEN_51) @[CU.scala 89:42 CU.scala 97:12]
    node _GEN_72 = mux(_T_5, f3, _GEN_52) @[CU.scala 89:42 CU.scala 98:15]
    node _GEN_73 = mux(_T_5, UInt<1>("h0"), _GEN_57) @[CU.scala 89:42 CU.scala 99:20]
    node _GEN_74 = mux(_T_5, _io_imm_T_5, _GEN_53) @[CU.scala 89:42 CU.scala 100:13]
    node _GEN_75 = mux(_T_5, UInt<1>("h0"), _GEN_49) @[CU.scala 89:42 CU.scala 45:19]
    node _GEN_76 = mux(_T_5, UInt<1>("h0"), _GEN_58) @[CU.scala 89:42 CU.scala 52:20]
    node _GEN_77 = mux(_T_5, UInt<1>("h0"), _GEN_60) @[CU.scala 89:42 CU.scala 51:17]
    node _GEN_78 = mux(_T_5, UInt<1>("h0"), _GEN_61) @[CU.scala 89:42 CU.scala 54:22]
    node _GEN_79 = mux(_T_5, UInt<1>("h0"), _GEN_62) @[CU.scala 89:42 CU.scala 55:22]
    node _GEN_80 = mux(_T_5, UInt<1>("h0"), _GEN_63) @[CU.scala 89:42 CU.scala 57:23]
    node _GEN_81 = mux(_T_5, UInt<1>("h0"), _GEN_64) @[CU.scala 89:42 CU.scala 56:24]
    node _GEN_82 = mux(_T_1, UInt<1>("h0"), UInt<1>("h0")) @[CU.scala 71:42 CU.scala 72:20 CU.scala 37:19]
    node _GEN_83 = mux(_T_1, UInt<1>("h1"), _GEN_65) @[CU.scala 71:42 CU.scala 73:18]
    node _GEN_84 = mux(_T_1, UInt<1>("h1"), _GEN_70) @[CU.scala 71:42 CU.scala 74:20]
    node _GEN_85 = mux(_T_1, _io_rd_T_1, _GEN_66) @[CU.scala 71:42 CU.scala 75:16]
    node _GEN_86 = mux(_T_1, _GEN_0, _GEN_68) @[CU.scala 71:42]
    node _GEN_87 = mux(_T_1, _io_rs1_T_1, _GEN_67) @[CU.scala 71:42 CU.scala 83:17]
    node _GEN_88 = mux(_T_1, UInt<1>("h0"), _GEN_73) @[CU.scala 71:42 CU.scala 84:23]
    node _GEN_89 = mux(_T_1, _io_imm_T_2, _GEN_74) @[CU.scala 71:42 CU.scala 86:20]
    node _GEN_90 = mux(_T_1, UInt<1>("h0"), _GEN_69) @[CU.scala 71:42 CU.scala 49:21]
    node _GEN_91 = mux(_T_1, UInt<1>("h0"), _GEN_71) @[CU.scala 71:42 CU.scala 42:16]
    node _GEN_92 = mux(_T_1, UInt<1>("h0"), _GEN_72) @[CU.scala 71:42 CU.scala 44:17]
    node _GEN_93 = mux(_T_1, UInt<1>("h0"), _GEN_75) @[CU.scala 71:42 CU.scala 45:19]
    node _GEN_94 = mux(_T_1, UInt<1>("h0"), _GEN_76) @[CU.scala 71:42 CU.scala 52:20]
    node _GEN_95 = mux(_T_1, UInt<1>("h0"), _GEN_77) @[CU.scala 71:42 CU.scala 51:17]
    node _GEN_96 = mux(_T_1, UInt<1>("h0"), _GEN_78) @[CU.scala 71:42 CU.scala 54:22]
    node _GEN_97 = mux(_T_1, UInt<1>("h0"), _GEN_79) @[CU.scala 71:42 CU.scala 55:22]
    node _GEN_98 = mux(_T_1, UInt<1>("h0"), _GEN_80) @[CU.scala 71:42 CU.scala 57:23]
    node _GEN_99 = mux(_T_1, UInt<1>("h0"), _GEN_81) @[CU.scala 71:42 CU.scala 56:24]
    node _GEN_100 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[CU.scala 61:39 CU.scala 62:20 CU.scala 38:19]
    node _GEN_101 = mux(_T, UInt<1>("h1"), _GEN_83) @[CU.scala 61:39 CU.scala 63:18]
    node _GEN_102 = mux(_T, UInt<1>("h1"), _GEN_84) @[CU.scala 61:39 CU.scala 64:20]
    node _GEN_103 = mux(_T, _io_rd_T, _GEN_85) @[CU.scala 61:39 CU.scala 65:16]
    node _GEN_104 = mux(_T, _io_aluop_T, _GEN_86) @[CU.scala 61:39 CU.scala 66:19]
    node _GEN_105 = mux(_T, _io_rs1_T, _GEN_87) @[CU.scala 61:39 CU.scala 67:17]
    node _GEN_106 = mux(_T, _io_rs2_T, _GEN_91) @[CU.scala 61:39 CU.scala 68:18]
    node _GEN_107 = mux(_T, UInt<1>("h0"), _GEN_88) @[CU.scala 61:39 CU.scala 69:23]
    node _GEN_108 = mux(_T, UInt<1>("h0"), _GEN_82) @[CU.scala 61:39 CU.scala 37:19]
    node _GEN_109 = mux(_T, UInt<1>("h0"), _GEN_89) @[CU.scala 61:39 CU.scala 39:16]
    node _GEN_110 = mux(_T, UInt<1>("h0"), _GEN_90) @[CU.scala 61:39 CU.scala 49:21]
    node _GEN_111 = mux(_T, UInt<1>("h0"), _GEN_92) @[CU.scala 61:39 CU.scala 44:17]
    node _GEN_112 = mux(_T, UInt<1>("h0"), _GEN_93) @[CU.scala 61:39 CU.scala 45:19]
    node _GEN_113 = mux(_T, UInt<1>("h0"), _GEN_94) @[CU.scala 61:39 CU.scala 52:20]
    node _GEN_114 = mux(_T, UInt<1>("h0"), _GEN_95) @[CU.scala 61:39 CU.scala 51:17]
    node _GEN_115 = mux(_T, UInt<1>("h0"), _GEN_96) @[CU.scala 61:39 CU.scala 54:22]
    node _GEN_116 = mux(_T, UInt<1>("h0"), _GEN_97) @[CU.scala 61:39 CU.scala 55:22]
    node _GEN_117 = mux(_T, UInt<1>("h0"), _GEN_98) @[CU.scala 61:39 CU.scala 57:23]
    node _GEN_118 = mux(_T, UInt<1>("h0"), _GEN_99) @[CU.scala 61:39 CU.scala 56:24]
    io_Opcode <= _io_Opcode_T @[CU.scala 36:19]
    io_aluop <= _GEN_104
    io_iformat <= _GEN_108
    io_rformat <= _GEN_100
    io_sformat <= _GEN_112
    io_bformat <= _GEN_113
    io_jalformate <= _GEN_115
    io_luiformate <= _GEN_116
    io_Auipcformate <= _GEN_118
    io_jalrformate <= _GEN_117
    io_rd <= _GEN_103
    io_fun_3 <= _GEN_111
    io_rs1 <= bits(_GEN_105, 4, 0)
    io_rs2 <= _GEN_106
    io_imm <= _GEN_109
    io_mem_wr_en <= _GEN_110
    io_Wr_en <= _GEN_101
    io_Wr_back <= _GEN_102
    io_bran_fn3 <= _GEN_107
    io_pcsel <= _GEN_114

  module ALUD :
    input clock : Clock
    input reset : UInt<1>
    input io_in_A : UInt<32>
    input io_in_B : UInt<32>
    input io_aluop : UInt<4>
    output io_out : UInt<32>

    node _T = eq(UInt<1>("h0"), io_aluop) @[Conditional.scala 37:30]
    node _io_out_T = add(io_in_A, io_in_B) @[ALU.scala 32:25]
    node _io_out_T_1 = tail(_io_out_T, 1) @[ALU.scala 32:25]
    node _T_1 = eq(UInt<1>("h1"), io_aluop) @[Conditional.scala 37:30]
    node _io_out_T_2 = sub(io_in_A, io_in_B) @[ALU.scala 35:29]
    node _io_out_T_3 = tail(_io_out_T_2, 1) @[ALU.scala 35:29]
    node _T_2 = eq(UInt<2>("h2"), io_aluop) @[Conditional.scala 37:30]
    node _io_out_T_4 = bits(io_in_B, 4, 0) @[ALU.scala 39:36]
    node _io_out_T_5 = dshl(io_in_A, _io_out_T_4) @[ALU.scala 39:25]
    node _T_3 = eq(UInt<3>("h4"), io_aluop) @[Conditional.scala 37:30]
    node _io_out_T_6 = asSInt(io_in_A) @[ALU.scala 42:26]
    node _io_out_T_7 = asSInt(io_in_B) @[ALU.scala 42:43]
    node _io_out_T_8 = lt(_io_out_T_6, _io_out_T_7) @[ALU.scala 42:33]
    node _T_4 = eq(UInt<3>("h6"), io_aluop) @[Conditional.scala 37:30]
    node _io_out_T_9 = lt(io_in_A, io_in_B) @[ALU.scala 45:26]
    node _T_5 = eq(UInt<4>("h8"), io_aluop) @[Conditional.scala 37:30]
    node _io_out_T_10 = xor(io_in_A, io_in_B) @[ALU.scala 48:25]
    node _T_6 = eq(UInt<4>("ha"), io_aluop) @[Conditional.scala 37:30]
    node _io_out_T_11 = bits(io_in_B, 4, 0) @[ALU.scala 51:38]
    node _io_out_T_12 = dshr(io_in_A, _io_out_T_11) @[ALU.scala 51:27]
    node _T_7 = eq(UInt<4>("hb"), io_aluop) @[Conditional.scala 37:30]
    node _io_out_T_13 = asSInt(io_in_A) @[ALU.scala 55:28]
    node _io_out_T_14 = bits(io_in_B, 4, 0) @[ALU.scala 55:46]
    node _io_out_T_15 = dshr(_io_out_T_13, _io_out_T_14) @[ALU.scala 55:35]
    node _io_out_T_16 = asUInt(_io_out_T_15) @[ALU.scala 55:62]
    node _T_8 = eq(UInt<4>("hc"), io_aluop) @[Conditional.scala 37:30]
    node _io_out_T_17 = or(io_in_A, io_in_B) @[ALU.scala 58:25]
    node _T_9 = eq(UInt<4>("he"), io_aluop) @[Conditional.scala 37:30]
    node _io_out_T_18 = and(io_in_A, io_in_B) @[ALU.scala 61:25]
    node _GEN_0 = mux(_T_9, _io_out_T_18, UInt<1>("h0")) @[Conditional.scala 39:67 ALU.scala 61:14 ALU.scala 27:10]
    node _GEN_1 = mux(_T_8, _io_out_T_17, _GEN_0) @[Conditional.scala 39:67 ALU.scala 58:14]
    node _GEN_2 = mux(_T_7, _io_out_T_16, _GEN_1) @[Conditional.scala 39:67 ALU.scala 55:16]
    node _GEN_3 = mux(_T_6, _io_out_T_12, _GEN_2) @[Conditional.scala 39:67 ALU.scala 51:16]
    node _GEN_4 = mux(_T_5, _io_out_T_10, _GEN_3) @[Conditional.scala 39:67 ALU.scala 48:14]
    node _GEN_5 = mux(_T_4, _io_out_T_9, _GEN_4) @[Conditional.scala 39:67 ALU.scala 45:14]
    node _GEN_6 = mux(_T_3, _io_out_T_8, _GEN_5) @[Conditional.scala 39:67 ALU.scala 42:14]
    node _GEN_7 = mux(_T_2, _io_out_T_5, _GEN_6) @[Conditional.scala 39:67 ALU.scala 39:14]
    node _GEN_8 = mux(_T_1, _io_out_T_3, _GEN_7) @[Conditional.scala 39:67 ALU.scala 35:18]
    node _GEN_9 = mux(_T, _io_out_T_1, _GEN_8) @[Conditional.scala 40:58 ALU.scala 32:14]
    io_out <= bits(_GEN_9, 31, 0)

  module Datamem :
    input clock : Clock
    input reset : UInt<1>
    input io_Wr_en : UInt<1>
    input io_address : UInt<32>
    input io_datain : UInt<32>
    output io_Dout : UInt<32>
    input io_fun3 : UInt<3>

    mem memory_0 : @[Datamemory.scala 16:20]
      data-type => UInt<8>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      reader => MPORT_2
      writer => MPORT
      read-under-write => undefined
    mem memory_1 : @[Datamemory.scala 16:20]
      data-type => UInt<8>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      reader => MPORT_2
      writer => MPORT
      read-under-write => undefined
    mem memory_2 : @[Datamemory.scala 16:20]
      data-type => UInt<8>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      reader => MPORT_2
      writer => MPORT
      read-under-write => undefined
    mem memory_3 : @[Datamemory.scala 16:20]
      data-type => UInt<8>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      reader => MPORT_2
      writer => MPORT
      read-under-write => undefined
    node _data_0_T = bits(io_datain, 7, 0) @[Datamemory.scala 28:23]
    node _data_1_T = bits(io_datain, 15, 8) @[Datamemory.scala 29:23]
    node _data_2_T = bits(io_datain, 23, 16) @[Datamemory.scala 30:23]
    node _data_3_T = bits(io_datain, 31, 24) @[Datamemory.scala 31:23]
    node _T = eq(io_fun3, UInt<1>("h0")) @[Datamemory.scala 34:16]
    node _T_1 = bits(io_address, 1, 0) @[Datamemory.scala 35:20]
    node _T_2 = eq(_T_1, UInt<1>("h0")) @[Datamemory.scala 35:25]
    node _data_0_T_1 = bits(io_datain, 7, 0) @[Datamemory.scala 44:27]
    node _T_3 = bits(io_address, 1, 0) @[Datamemory.scala 46:25]
    node _T_4 = eq(_T_3, UInt<1>("h1")) @[Datamemory.scala 46:31]
    node _data_1_T_1 = bits(io_datain, 7, 0) @[Datamemory.scala 54:27]
    node _T_5 = bits(io_address, 1, 0) @[Datamemory.scala 58:25]
    node _T_6 = eq(_T_5, UInt<2>("h2")) @[Datamemory.scala 58:31]
    node _data_2_T_1 = bits(io_datain, 7, 0) @[Datamemory.scala 65:27]
    node _T_7 = bits(io_address, 1, 0) @[Datamemory.scala 67:26]
    node _T_8 = eq(_T_7, UInt<2>("h3")) @[Datamemory.scala 67:32]
    node _data_3_T_1 = bits(io_datain, 7, 0) @[Datamemory.scala 74:27]
    node _T_9 = eq(io_fun3, UInt<1>("h1")) @[Datamemory.scala 78:21]
    node _T_10 = bits(io_address, 1, 0) @[Datamemory.scala 80:21]
    node _T_11 = eq(_T_10, UInt<1>("h0")) @[Datamemory.scala 80:28]
    node _data_0_T_2 = bits(io_datain, 7, 0) @[Datamemory.scala 86:27]
    node _data_1_T_2 = bits(io_datain, 15, 8) @[Datamemory.scala 87:27]
    node _T_12 = bits(io_address, 1, 0) @[Datamemory.scala 88:26]
    node _T_13 = eq(_T_12, UInt<1>("h1")) @[Datamemory.scala 88:33]
    node _data_1_T_3 = bits(io_datain, 7, 0) @[Datamemory.scala 95:27]
    node _data_2_T_2 = bits(io_datain, 15, 8) @[Datamemory.scala 96:27]
    node _T_14 = bits(io_address, 1, 0) @[Datamemory.scala 98:26]
    node _T_15 = eq(_T_14, UInt<2>("h2")) @[Datamemory.scala 98:33]
    node _data_2_T_3 = bits(io_datain, 7, 0) @[Datamemory.scala 105:26]
    node _data_3_T_2 = bits(io_datain, 15, 8) @[Datamemory.scala 106:27]
    node _T_16 = bits(io_address, 1, 0) @[Datamemory.scala 108:26]
    node _T_17 = eq(_T_16, UInt<2>("h3")) @[Datamemory.scala 108:33]
    node _data_3_T_3 = bits(io_datain, 7, 0) @[Datamemory.scala 115:26]
    node _data_0_T_3 = bits(io_datain, 15, 8) @[Datamemory.scala 116:27]
    node _GEN_0 = mux(_T_17, UInt<1>("h1"), UInt<1>("h0")) @[Datamemory.scala 108:42 Datamemory.scala 110:15 Datamemory.scala 23:11]
    node _GEN_1 = mux(_T_17, _data_3_T_3, _data_3_T) @[Datamemory.scala 108:42 Datamemory.scala 115:15 Datamemory.scala 31:11]
    node _GEN_2 = mux(_T_17, _data_0_T_3, _data_0_T) @[Datamemory.scala 108:42 Datamemory.scala 116:15 Datamemory.scala 28:11]
    node _GEN_3 = mux(_T_15, UInt<1>("h1"), UInt<1>("h0")) @[Datamemory.scala 98:42 Datamemory.scala 102:15 Datamemory.scala 25:11]
    node _GEN_4 = mux(_T_15, UInt<1>("h1"), _GEN_0) @[Datamemory.scala 98:42 Datamemory.scala 103:15]
    node _GEN_5 = mux(_T_15, _data_2_T_3, _data_2_T) @[Datamemory.scala 98:42 Datamemory.scala 105:15 Datamemory.scala 30:11]
    node _GEN_6 = mux(_T_15, _data_3_T_2, _GEN_1) @[Datamemory.scala 98:42 Datamemory.scala 106:15]
    node _GEN_7 = mux(_T_15, UInt<1>("h0"), _GEN_0) @[Datamemory.scala 98:42 Datamemory.scala 23:11]
    node _GEN_8 = mux(_T_15, _data_0_T, _GEN_2) @[Datamemory.scala 98:42 Datamemory.scala 28:11]
    node _GEN_9 = mux(_T_13, UInt<1>("h1"), UInt<1>("h0")) @[Datamemory.scala 88:42 Datamemory.scala 91:15 Datamemory.scala 24:11]
    node _GEN_10 = mux(_T_13, UInt<1>("h0"), _GEN_4) @[Datamemory.scala 88:42 Datamemory.scala 93:15]
    node _GEN_11 = mux(_T_13, _data_1_T_3, _data_1_T) @[Datamemory.scala 88:42 Datamemory.scala 95:15 Datamemory.scala 29:11]
    node _GEN_12 = mux(_T_13, _data_2_T_2, _GEN_5) @[Datamemory.scala 88:42 Datamemory.scala 96:15]
    node _GEN_13 = mux(_T_13, UInt<1>("h0"), _GEN_3) @[Datamemory.scala 88:42 Datamemory.scala 25:11]
    node _GEN_14 = mux(_T_13, _data_3_T, _GEN_6) @[Datamemory.scala 88:42 Datamemory.scala 31:11]
    node _GEN_15 = mux(_T_13, UInt<1>("h0"), _GEN_7) @[Datamemory.scala 88:42 Datamemory.scala 23:11]
    node _GEN_16 = mux(_T_13, _data_0_T, _GEN_8) @[Datamemory.scala 88:42 Datamemory.scala 28:11]
    node _GEN_17 = mux(_T_11, UInt<1>("h1"), _GEN_15) @[Datamemory.scala 80:37 Datamemory.scala 81:15]
    node _GEN_18 = mux(_T_11, UInt<1>("h1"), _GEN_9) @[Datamemory.scala 80:37 Datamemory.scala 82:15]
    node _GEN_19 = mux(_T_11, _data_0_T_2, _GEN_16) @[Datamemory.scala 80:37 Datamemory.scala 86:15]
    node _GEN_20 = mux(_T_11, _data_1_T_2, _GEN_11) @[Datamemory.scala 80:37 Datamemory.scala 87:15]
    node _GEN_21 = mux(_T_11, UInt<1>("h0"), _GEN_10) @[Datamemory.scala 80:37 Datamemory.scala 26:11]
    node _GEN_22 = mux(_T_11, _data_2_T, _GEN_12) @[Datamemory.scala 80:37 Datamemory.scala 30:11]
    node _GEN_23 = mux(_T_11, UInt<1>("h0"), _GEN_13) @[Datamemory.scala 80:37 Datamemory.scala 25:11]
    node _GEN_24 = mux(_T_11, _data_3_T, _GEN_14) @[Datamemory.scala 80:37 Datamemory.scala 31:11]
    node _T_18 = eq(io_fun3, UInt<2>("h2")) @[Datamemory.scala 120:22]
    node _data_0_T_4 = bits(io_datain, 7, 0) @[Datamemory.scala 130:23]
    node _data_1_T_4 = bits(io_datain, 15, 8) @[Datamemory.scala 131:23]
    node _data_2_T_4 = bits(io_datain, 23, 16) @[Datamemory.scala 132:23]
    node _data_3_T_4 = bits(io_datain, 31, 24) @[Datamemory.scala 133:23]
    node _GEN_25 = mux(_T_18, UInt<1>("h1"), UInt<1>("h0")) @[Datamemory.scala 120:30 Datamemory.scala 125:15 Datamemory.scala 23:11]
    node _GEN_26 = mux(_T_18, _data_0_T_4, _data_0_T) @[Datamemory.scala 120:30 Datamemory.scala 130:11 Datamemory.scala 28:11]
    node _GEN_27 = mux(_T_18, _data_1_T_4, _data_1_T) @[Datamemory.scala 120:30 Datamemory.scala 131:11 Datamemory.scala 29:11]
    node _GEN_28 = mux(_T_18, _data_2_T_4, _data_2_T) @[Datamemory.scala 120:30 Datamemory.scala 132:11 Datamemory.scala 30:11]
    node _GEN_29 = mux(_T_18, _data_3_T_4, _data_3_T) @[Datamemory.scala 120:30 Datamemory.scala 133:11 Datamemory.scala 31:11]
    node _GEN_30 = mux(_T_9, _GEN_17, _GEN_25) @[Datamemory.scala 78:29]
    node _GEN_31 = mux(_T_9, _GEN_18, _GEN_25) @[Datamemory.scala 78:29]
    node _GEN_32 = mux(_T_9, _GEN_19, _GEN_26) @[Datamemory.scala 78:29]
    node _GEN_33 = mux(_T_9, _GEN_20, _GEN_27) @[Datamemory.scala 78:29]
    node _GEN_34 = mux(_T_9, _GEN_21, _GEN_25) @[Datamemory.scala 78:29]
    node _GEN_35 = mux(_T_9, _GEN_22, _GEN_28) @[Datamemory.scala 78:29]
    node _GEN_36 = mux(_T_9, _GEN_23, _GEN_25) @[Datamemory.scala 78:29]
    node _GEN_37 = mux(_T_9, _GEN_24, _GEN_29) @[Datamemory.scala 78:29]
    node _GEN_38 = mux(_T_8, UInt<1>("h1"), _GEN_34) @[Datamemory.scala 67:40 Datamemory.scala 72:15]
    node _GEN_39 = mux(_T_8, _data_3_T_1, _GEN_37) @[Datamemory.scala 67:40 Datamemory.scala 74:15]
    node _GEN_40 = mux(_T_8, UInt<1>("h0"), _GEN_30) @[Datamemory.scala 67:40 Datamemory.scala 23:11]
    node _GEN_41 = mux(_T_8, UInt<1>("h0"), _GEN_31) @[Datamemory.scala 67:40 Datamemory.scala 24:11]
    node _GEN_42 = mux(_T_8, _data_0_T, _GEN_32) @[Datamemory.scala 67:40 Datamemory.scala 28:11]
    node _GEN_43 = mux(_T_8, _data_1_T, _GEN_33) @[Datamemory.scala 67:40 Datamemory.scala 29:11]
    node _GEN_44 = mux(_T_8, _data_2_T, _GEN_35) @[Datamemory.scala 67:40 Datamemory.scala 30:11]
    node _GEN_45 = mux(_T_8, UInt<1>("h0"), _GEN_36) @[Datamemory.scala 67:40 Datamemory.scala 25:11]
    node _GEN_46 = mux(_T_6, UInt<1>("h1"), _GEN_45) @[Datamemory.scala 58:39 Datamemory.scala 62:15]
    node _GEN_47 = mux(_T_6, _data_2_T_1, _GEN_44) @[Datamemory.scala 58:39 Datamemory.scala 65:15]
    node _GEN_48 = mux(_T_6, UInt<1>("h0"), _GEN_38) @[Datamemory.scala 58:39 Datamemory.scala 26:11]
    node _GEN_49 = mux(_T_6, _data_3_T, _GEN_39) @[Datamemory.scala 58:39 Datamemory.scala 31:11]
    node _GEN_50 = mux(_T_6, UInt<1>("h0"), _GEN_40) @[Datamemory.scala 58:39 Datamemory.scala 23:11]
    node _GEN_51 = mux(_T_6, UInt<1>("h0"), _GEN_41) @[Datamemory.scala 58:39 Datamemory.scala 24:11]
    node _GEN_52 = mux(_T_6, _data_0_T, _GEN_42) @[Datamemory.scala 58:39 Datamemory.scala 28:11]
    node _GEN_53 = mux(_T_6, _data_1_T, _GEN_43) @[Datamemory.scala 58:39 Datamemory.scala 29:11]
    node _GEN_54 = mux(_T_4, UInt<1>("h1"), _GEN_51) @[Datamemory.scala 46:39 Datamemory.scala 50:15]
    node _GEN_55 = mux(_T_4, UInt<1>("h0"), _GEN_46) @[Datamemory.scala 46:39 Datamemory.scala 51:15]
    node _GEN_56 = mux(_T_4, UInt<1>("h0"), _GEN_48) @[Datamemory.scala 46:39 Datamemory.scala 52:15]
    node _GEN_57 = mux(_T_4, _data_1_T_1, _GEN_53) @[Datamemory.scala 46:39 Datamemory.scala 54:15]
    node _GEN_58 = mux(_T_4, _data_2_T, _GEN_47) @[Datamemory.scala 46:39 Datamemory.scala 30:11]
    node _GEN_59 = mux(_T_4, _data_3_T, _GEN_49) @[Datamemory.scala 46:39 Datamemory.scala 31:11]
    node _GEN_60 = mux(_T_4, UInt<1>("h0"), _GEN_50) @[Datamemory.scala 46:39 Datamemory.scala 23:11]
    node _GEN_61 = mux(_T_4, _data_0_T, _GEN_52) @[Datamemory.scala 46:39 Datamemory.scala 28:11]
    node _GEN_62 = mux(_T_2, UInt<1>("h1"), _GEN_60) @[Datamemory.scala 35:33 Datamemory.scala 39:15]
    node _GEN_63 = mux(_T_2, _data_0_T_1, _GEN_61) @[Datamemory.scala 35:33 Datamemory.scala 44:15]
    node _GEN_64 = mux(_T_2, UInt<1>("h0"), _GEN_54) @[Datamemory.scala 35:33 Datamemory.scala 24:11]
    node _GEN_65 = mux(_T_2, UInt<1>("h0"), _GEN_55) @[Datamemory.scala 35:33 Datamemory.scala 25:11]
    node _GEN_66 = mux(_T_2, UInt<1>("h0"), _GEN_56) @[Datamemory.scala 35:33 Datamemory.scala 26:11]
    node _GEN_67 = mux(_T_2, _data_1_T, _GEN_57) @[Datamemory.scala 35:33 Datamemory.scala 29:11]
    node _GEN_68 = mux(_T_2, _data_2_T, _GEN_58) @[Datamemory.scala 35:33 Datamemory.scala 30:11]
    node _GEN_69 = mux(_T_2, _data_3_T, _GEN_59) @[Datamemory.scala 35:33 Datamemory.scala 31:11]
    node _GEN_70 = mux(_T, _GEN_62, UInt<1>("h0")) @[Datamemory.scala 34:24 Datamemory.scala 23:11]
    node _GEN_71 = mux(_T, _GEN_63, _data_0_T) @[Datamemory.scala 34:24 Datamemory.scala 28:11]
    node _GEN_72 = mux(_T, _GEN_64, UInt<1>("h0")) @[Datamemory.scala 34:24 Datamemory.scala 24:11]
    node _GEN_73 = mux(_T, _GEN_65, UInt<1>("h0")) @[Datamemory.scala 34:24 Datamemory.scala 25:11]
    node _GEN_74 = mux(_T, _GEN_66, UInt<1>("h0")) @[Datamemory.scala 34:24 Datamemory.scala 26:11]
    node _GEN_75 = mux(_T, _GEN_67, _data_1_T) @[Datamemory.scala 34:24 Datamemory.scala 29:11]
    node _GEN_76 = mux(_T, _GEN_68, _data_2_T) @[Datamemory.scala 34:24 Datamemory.scala 30:11]
    node _GEN_77 = mux(_T, _GEN_69, _data_3_T) @[Datamemory.scala 34:24 Datamemory.scala 31:11]
    node _T_19 = bits(io_address, 31, 2) @[Datamemory.scala 139:26]
    node _T_20 = bits(_T_19, 9, 0)
    node _GEN_86 = mux(io_Wr_en, _GEN_70, UInt<1>("h0")) @[Datamemory.scala 33:15 Datamemory.scala 23:11]
    node mask_0 = _GEN_86 @[Datamemory.scala 17:18]
    node _GEN_87 = mux(io_Wr_en, _GEN_71, _data_0_T) @[Datamemory.scala 33:15 Datamemory.scala 28:11]
    node data_0 = _GEN_87 @[Datamemory.scala 18:18]
    node _GEN_78 = validif(mask_0, data_0)
    node _GEN_79 = mux(mask_0, UInt<1>("h1"), UInt<1>("h0"))
    node _GEN_88 = mux(io_Wr_en, _GEN_72, UInt<1>("h0")) @[Datamemory.scala 33:15 Datamemory.scala 24:11]
    node mask_1 = _GEN_88 @[Datamemory.scala 17:18]
    node _GEN_91 = mux(io_Wr_en, _GEN_75, _data_1_T) @[Datamemory.scala 33:15 Datamemory.scala 29:11]
    node data_1 = _GEN_91 @[Datamemory.scala 18:18]
    node _GEN_80 = validif(mask_1, data_1)
    node _GEN_81 = mux(mask_1, UInt<1>("h1"), UInt<1>("h0"))
    node _GEN_89 = mux(io_Wr_en, _GEN_73, UInt<1>("h0")) @[Datamemory.scala 33:15 Datamemory.scala 25:11]
    node mask_2 = _GEN_89 @[Datamemory.scala 17:18]
    node _GEN_92 = mux(io_Wr_en, _GEN_76, _data_2_T) @[Datamemory.scala 33:15 Datamemory.scala 30:11]
    node data_2 = _GEN_92 @[Datamemory.scala 18:18]
    node _GEN_82 = validif(mask_2, data_2)
    node _GEN_83 = mux(mask_2, UInt<1>("h1"), UInt<1>("h0"))
    node _GEN_90 = mux(io_Wr_en, _GEN_74, UInt<1>("h0")) @[Datamemory.scala 33:15 Datamemory.scala 26:11]
    node mask_3 = _GEN_90 @[Datamemory.scala 17:18]
    node _GEN_93 = mux(io_Wr_en, _GEN_77, _data_3_T) @[Datamemory.scala 33:15 Datamemory.scala 31:11]
    node data_3 = _GEN_93 @[Datamemory.scala 18:18]
    node _GEN_84 = validif(mask_3, data_3)
    node _GEN_85 = mux(mask_3, UInt<1>("h1"), UInt<1>("h0"))
    node _T_21 = bits(io_address, 31, 2) @[Datamemory.scala 140:32]
    node _T_22 = bits(_T_21, 9, 0) @[Datamemory.scala 140:21]
    node _GEN_94 = validif(io_Wr_en, _T_20) @[Datamemory.scala 33:15]
    node _GEN_95 = validif(io_Wr_en, clock) @[Datamemory.scala 33:15]
    node _GEN_96 = mux(io_Wr_en, UInt<1>("h1"), UInt<1>("h0")) @[Datamemory.scala 33:15 Datamemory.scala 16:20]
    node _GEN_97 = validif(io_Wr_en, _GEN_79) @[Datamemory.scala 33:15]
    node _GEN_98 = validif(io_Wr_en, _GEN_81) @[Datamemory.scala 33:15]
    node _GEN_99 = validif(io_Wr_en, _GEN_83) @[Datamemory.scala 33:15]
    node _GEN_100 = validif(io_Wr_en, _GEN_85) @[Datamemory.scala 33:15]
    node _GEN_101 = validif(io_Wr_en, _GEN_78) @[Datamemory.scala 33:15]
    node _GEN_102 = validif(io_Wr_en, _GEN_80) @[Datamemory.scala 33:15]
    node _GEN_103 = validif(io_Wr_en, _GEN_82) @[Datamemory.scala 33:15]
    node _GEN_104 = validif(io_Wr_en, _GEN_84) @[Datamemory.scala 33:15]
    node _GEN_105 = validif(io_Wr_en, _T_22) @[Datamemory.scala 33:15 Datamemory.scala 140:21]
    node _T_23 = bits(io_address, 31, 2) @[Datamemory.scala 143:30]
    node _T_24 = bits(_T_23, 9, 0) @[Datamemory.scala 143:19]
    node _T_25 = eq(io_fun3, UInt<1>("h0")) @[Datamemory.scala 145:14]
    node _T_26 = bits(io_address, 1, 0) @[Datamemory.scala 146:20]
    node _T_27 = eq(_T_26, UInt<1>("h0")) @[Datamemory.scala 146:26]
    node temp_0 = memory_0.MPORT_2.data @[Datamemory.scala 19:18 Datamemory.scala 143:5]
    node _io_Dout_T = bits(temp_0, 7, 7) @[Datamemory.scala 147:35]
    node _io_Dout_T_1 = bits(_io_Dout_T, 0, 0) @[Bitwise.scala 72:15]
    node io_Dout_hi = mux(_io_Dout_T_1, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_Dout_T_2 = cat(io_Dout_hi, temp_0) @[Cat.scala 30:58]
    node _T_28 = bits(io_address, 1, 0) @[Datamemory.scala 148:25]
    node _T_29 = eq(_T_28, UInt<1>("h1")) @[Datamemory.scala 148:30]
    node temp_1 = memory_1.MPORT_2.data @[Datamemory.scala 19:18 Datamemory.scala 143:5]
    node _io_Dout_T_3 = bits(temp_1, 7, 7) @[Datamemory.scala 149:35]
    node _io_Dout_T_4 = bits(_io_Dout_T_3, 0, 0) @[Bitwise.scala 72:15]
    node io_Dout_hi_1 = mux(_io_Dout_T_4, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_Dout_T_5 = cat(io_Dout_hi_1, temp_1) @[Cat.scala 30:58]
    node _T_30 = bits(io_address, 1, 0) @[Datamemory.scala 150:25]
    node _T_31 = eq(_T_30, UInt<2>("h2")) @[Datamemory.scala 150:30]
    node temp_2 = memory_2.MPORT_2.data @[Datamemory.scala 19:18 Datamemory.scala 143:5]
    node _io_Dout_T_6 = bits(temp_2, 7, 7) @[Datamemory.scala 151:35]
    node _io_Dout_T_7 = bits(_io_Dout_T_6, 0, 0) @[Bitwise.scala 72:15]
    node io_Dout_hi_2 = mux(_io_Dout_T_7, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_Dout_T_8 = cat(io_Dout_hi_2, temp_2) @[Cat.scala 30:58]
    node _T_32 = bits(io_address, 1, 0) @[Datamemory.scala 152:25]
    node _T_33 = eq(_T_32, UInt<2>("h3")) @[Datamemory.scala 152:30]
    node temp_3 = memory_3.MPORT_2.data @[Datamemory.scala 19:18 Datamemory.scala 143:5]
    node _io_Dout_T_9 = bits(temp_3, 7, 7) @[Datamemory.scala 153:35]
    node _io_Dout_T_10 = bits(_io_Dout_T_9, 0, 0) @[Bitwise.scala 72:15]
    node io_Dout_hi_3 = mux(_io_Dout_T_10, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_Dout_T_11 = cat(io_Dout_hi_3, temp_3) @[Cat.scala 30:58]
    node _GEN_106 = mux(_T_33, _io_Dout_T_11, UInt<1>("h0")) @[Datamemory.scala 152:38 Datamemory.scala 153:13 Datamemory.scala 21:11]
    node _GEN_107 = mux(_T_31, _io_Dout_T_8, _GEN_106) @[Datamemory.scala 150:38 Datamemory.scala 151:13]
    node _GEN_108 = mux(_T_29, _io_Dout_T_5, _GEN_107) @[Datamemory.scala 148:38 Datamemory.scala 149:13]
    node _GEN_109 = mux(_T_27, _io_Dout_T_2, _GEN_108) @[Datamemory.scala 146:34 Datamemory.scala 147:13]
    node _T_34 = eq(io_fun3, UInt<1>("h1")) @[Datamemory.scala 155:22]
    node _T_35 = bits(io_address, 1, 0) @[Datamemory.scala 156:20]
    node _T_36 = eq(_T_35, UInt<1>("h0")) @[Datamemory.scala 156:26]
    node _io_Dout_T_12 = bits(temp_0, 7, 7) @[Datamemory.scala 157:35]
    node _io_Dout_T_13 = bits(_io_Dout_T_12, 0, 0) @[Bitwise.scala 72:15]
    node io_Dout_hi_hi = mux(_io_Dout_T_13, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_Dout_hi_4 = cat(io_Dout_hi_hi, temp_0) @[Cat.scala 30:58]
    node _io_Dout_T_14 = cat(io_Dout_hi_4, temp_1) @[Cat.scala 30:58]
    node _T_37 = bits(io_address, 1, 0) @[Datamemory.scala 158:25]
    node _T_38 = eq(_T_37, UInt<1>("h1")) @[Datamemory.scala 158:30]
    node _io_Dout_T_15 = bits(temp_1, 7, 7) @[Datamemory.scala 159:35]
    node _io_Dout_T_16 = bits(_io_Dout_T_15, 0, 0) @[Bitwise.scala 72:15]
    node io_Dout_hi_hi_1 = mux(_io_Dout_T_16, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_Dout_hi_5 = cat(io_Dout_hi_hi_1, temp_1) @[Cat.scala 30:58]
    node _io_Dout_T_17 = cat(io_Dout_hi_5, temp_2) @[Cat.scala 30:58]
    node _T_39 = bits(io_address, 1, 0) @[Datamemory.scala 160:25]
    node _T_40 = eq(_T_39, UInt<2>("h2")) @[Datamemory.scala 160:30]
    node _io_Dout_T_18 = bits(temp_2, 7, 7) @[Datamemory.scala 161:35]
    node _io_Dout_T_19 = bits(_io_Dout_T_18, 0, 0) @[Bitwise.scala 72:15]
    node io_Dout_hi_hi_2 = mux(_io_Dout_T_19, UInt<16>("hffff"), UInt<16>("h0")) @[Bitwise.scala 72:12]
    node io_Dout_hi_6 = cat(io_Dout_hi_hi_2, temp_2) @[Cat.scala 30:58]
    node _io_Dout_T_20 = cat(io_Dout_hi_6, temp_3) @[Cat.scala 30:58]
    node _T_41 = bits(io_address, 1, 0) @[Datamemory.scala 162:25]
    node _T_42 = eq(_T_41, UInt<2>("h3")) @[Datamemory.scala 162:30]
    node _io_Dout_T_21 = bits(temp_3, 7, 7) @[Datamemory.scala 163:35]
    node _io_Dout_T_22 = bits(_io_Dout_T_21, 0, 0) @[Bitwise.scala 72:15]
    node io_Dout_hi_7 = mux(_io_Dout_T_22, UInt<24>("hffffff"), UInt<24>("h0")) @[Bitwise.scala 72:12]
    node _io_Dout_T_23 = cat(io_Dout_hi_7, temp_3) @[Cat.scala 30:58]
    node _GEN_110 = mux(_T_42, _io_Dout_T_23, UInt<1>("h0")) @[Datamemory.scala 162:38 Datamemory.scala 163:13 Datamemory.scala 21:11]
    node _GEN_111 = mux(_T_40, _io_Dout_T_20, _GEN_110) @[Datamemory.scala 160:38 Datamemory.scala 161:13]
    node _GEN_112 = mux(_T_38, _io_Dout_T_17, _GEN_111) @[Datamemory.scala 158:38 Datamemory.scala 159:13]
    node _GEN_113 = mux(_T_36, _io_Dout_T_14, _GEN_112) @[Datamemory.scala 156:34 Datamemory.scala 157:13]
    node _T_43 = eq(io_fun3, UInt<2>("h2")) @[Datamemory.scala 164:22]
    node io_Dout_lo = cat(temp_1, temp_0) @[Cat.scala 30:58]
    node io_Dout_hi_8 = cat(temp_3, temp_2) @[Cat.scala 30:58]
    node _io_Dout_T_24 = cat(io_Dout_hi_8, io_Dout_lo) @[Cat.scala 30:58]
    node _GEN_114 = mux(_T_43, _io_Dout_T_24, UInt<1>("h0")) @[Datamemory.scala 164:31 Datamemory.scala 165:13 Datamemory.scala 21:11]
    node _GEN_115 = mux(_T_34, _GEN_113, _GEN_114) @[Datamemory.scala 155:31]
    node _GEN_116 = mux(_T_25, _GEN_109, _GEN_115) @[Datamemory.scala 145:23]
    io_Dout <= _GEN_116
    memory_0.MPORT_1.addr <= _GEN_105
    memory_1.MPORT_1.addr <= _GEN_105
    memory_2.MPORT_1.addr <= _GEN_105
    memory_3.MPORT_1.addr <= _GEN_105
    memory_0.MPORT_1.en <= _GEN_96
    memory_1.MPORT_1.en <= _GEN_96
    memory_2.MPORT_1.en <= _GEN_96
    memory_3.MPORT_1.en <= _GEN_96
    memory_0.MPORT_1.clk <= _GEN_95
    memory_1.MPORT_1.clk <= _GEN_95
    memory_2.MPORT_1.clk <= _GEN_95
    memory_3.MPORT_1.clk <= _GEN_95
    memory_0.MPORT_2.addr <= _T_24 @[Datamemory.scala 143:19]
    memory_1.MPORT_2.addr <= _T_24 @[Datamemory.scala 143:19]
    memory_2.MPORT_2.addr <= _T_24 @[Datamemory.scala 143:19]
    memory_3.MPORT_2.addr <= _T_24 @[Datamemory.scala 143:19]
    memory_0.MPORT_2.en <= UInt<1>("h1") @[Datamemory.scala 143:19]
    memory_1.MPORT_2.en <= UInt<1>("h1") @[Datamemory.scala 143:19]
    memory_2.MPORT_2.en <= UInt<1>("h1") @[Datamemory.scala 143:19]
    memory_3.MPORT_2.en <= UInt<1>("h1") @[Datamemory.scala 143:19]
    memory_0.MPORT_2.clk <= clock @[Datamemory.scala 143:19]
    memory_1.MPORT_2.clk <= clock @[Datamemory.scala 143:19]
    memory_2.MPORT_2.clk <= clock @[Datamemory.scala 143:19]
    memory_3.MPORT_2.clk <= clock @[Datamemory.scala 143:19]
    memory_0.MPORT.addr <= _GEN_94
    memory_1.MPORT.addr <= _GEN_94
    memory_2.MPORT.addr <= _GEN_94
    memory_3.MPORT.addr <= _GEN_94
    memory_0.MPORT.en <= _GEN_96
    memory_1.MPORT.en <= _GEN_96
    memory_2.MPORT.en <= _GEN_96
    memory_3.MPORT.en <= _GEN_96
    memory_0.MPORT.clk <= _GEN_95
    memory_1.MPORT.clk <= _GEN_95
    memory_2.MPORT.clk <= _GEN_95
    memory_3.MPORT.clk <= _GEN_95
    memory_0.MPORT.data <= _GEN_101
    memory_1.MPORT.data <= _GEN_102
    memory_2.MPORT.data <= _GEN_103
    memory_3.MPORT.data <= _GEN_104
    memory_0.MPORT.mask <= _GEN_97
    memory_1.MPORT.mask <= _GEN_98
    memory_2.MPORT.mask <= _GEN_99
    memory_3.MPORT.mask <= _GEN_100

  module BranchControl :
    input clock : Clock
    input reset : UInt<1>
    input io_fnct3 : UInt<3>
    input io_branch : UInt<1>
    input io_arg_x : UInt<32>
    input io_arg_y : UInt<32>
    output io_br_taken : UInt<1>

    node _T = eq(UInt<1>("h0"), io_fnct3) @[Conditional.scala 37:30]
    node _T_1 = eq(io_arg_x, io_arg_y) @[Branch.scala 17:24]
    node _T_2 = eq(io_branch, UInt<1>("h1")) @[Branch.scala 17:52]
    node _T_3 = and(_T_1, _T_2) @[Branch.scala 17:38]
    node _GEN_0 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[Branch.scala 17:61 Branch.scala 18:24 Branch.scala 13:13]
    node _T_4 = eq(UInt<1>("h1"), io_fnct3) @[Conditional.scala 37:30]
    node _T_5 = neq(io_arg_x, io_arg_y) @[Branch.scala 23:23]
    node _T_6 = eq(io_branch, UInt<1>("h1")) @[Branch.scala 23:50]
    node _T_7 = and(_T_5, _T_6) @[Branch.scala 23:36]
    node _GEN_1 = mux(_T_7, UInt<1>("h1"), UInt<1>("h0")) @[Branch.scala 23:59 Branch.scala 24:24 Branch.scala 13:13]
    node _T_8 = eq(UInt<3>("h4"), io_fnct3) @[Conditional.scala 37:30]
    node _T_9 = lt(io_arg_x, io_arg_y) @[Branch.scala 29:23]
    node _T_10 = eq(io_branch, UInt<1>("h1")) @[Branch.scala 29:48]
    node _T_11 = and(_T_9, _T_10) @[Branch.scala 29:34]
    node _GEN_2 = mux(_T_11, UInt<1>("h1"), UInt<1>("h0")) @[Branch.scala 29:57 Branch.scala 30:24 Branch.scala 13:13]
    node _T_12 = eq(UInt<3>("h5"), io_fnct3) @[Conditional.scala 37:30]
    node _T_13 = geq(io_arg_x, io_arg_y) @[Branch.scala 35:24]
    node _T_14 = eq(io_branch, UInt<1>("h1")) @[Branch.scala 35:50]
    node _T_15 = and(_T_13, _T_14) @[Branch.scala 35:36]
    node _GEN_3 = mux(_T_15, UInt<1>("h1"), UInt<1>("h0")) @[Branch.scala 35:59 Branch.scala 36:24 Branch.scala 13:13]
    node _T_16 = eq(UInt<3>("h6"), io_fnct3) @[Conditional.scala 37:30]
    node _T_17 = lt(io_arg_x, io_arg_y) @[Branch.scala 41:23]
    node _T_18 = eq(io_branch, UInt<1>("h1")) @[Branch.scala 41:48]
    node _T_19 = and(_T_17, _T_18) @[Branch.scala 41:34]
    node _GEN_4 = mux(_T_19, UInt<1>("h1"), UInt<1>("h0")) @[Branch.scala 41:57 Branch.scala 42:24 Branch.scala 13:13]
    node _T_20 = eq(UInt<3>("h7"), io_fnct3) @[Conditional.scala 37:30]
    node _T_21 = geq(io_arg_x, io_arg_y) @[Branch.scala 47:23]
    node _T_22 = eq(io_branch, UInt<1>("h1")) @[Branch.scala 47:49]
    node _T_23 = and(_T_21, _T_22) @[Branch.scala 47:35]
    node _GEN_5 = mux(_T_23, UInt<1>("h1"), UInt<1>("h0")) @[Branch.scala 47:58 Branch.scala 48:24 Branch.scala 13:13]
    node _GEN_6 = mux(_T_20, _GEN_5, UInt<1>("h0")) @[Conditional.scala 39:67 Branch.scala 13:13]
    node _GEN_7 = mux(_T_16, _GEN_4, _GEN_6) @[Conditional.scala 39:67]
    node _GEN_8 = mux(_T_12, _GEN_3, _GEN_7) @[Conditional.scala 39:67]
    node _GEN_9 = mux(_T_8, _GEN_2, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_10 = mux(_T_4, _GEN_1, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_11 = mux(_T, _GEN_0, _GEN_10) @[Conditional.scala 40:58]
    io_br_taken <= _GEN_11

  module Datapath :
    input clock : Clock
    input reset : UInt<1>
    output io_Pcout : UInt<32>
    input io_insin : UInt<32>
    output io_out : UInt<32>

    inst pc of Pc @[Datapath.scala 13:23]
    inst im of InstMem @[Datapath.scala 14:22]
    inst reg of register @[Datapath.scala 15:23]
    inst cu of controlunit @[Datapath.scala 16:23]
    inst alu of ALUD @[Datapath.scala 17:24]
    inst dmem of Datamem @[Datapath.scala 18:24]
    inst Bran of BranchControl @[Datapath.scala 19:24]
    reg pc_r : UInt<32>, clock with :
      reset => (UInt<1>("h0"), pc_r) @[Datapath.scala 22:25]
    node _pc_r_T = add(pc_r, UInt<3>("h4")) @[Datapath.scala 28:55]
    node _pc_r_T_1 = tail(_pc_r_T, 1) @[Datapath.scala 28:55]
    node _pc_r_T_2 = mux(cu.io_pcsel, alu.io_out, _pc_r_T_1) @[Datapath.scala 28:18]
    node _T = eq(cu.io_Wr_back, UInt<1>("h0")) @[Datapath.scala 39:26]
    node _T_1 = eq(cu.io_Wr_back, UInt<1>("h1")) @[Datapath.scala 44:31]
    node _T_2 = eq(cu.io_Wr_back, UInt<2>("h2")) @[Datapath.scala 48:31]
    node _reg_io_data_T = add(pc_r, UInt<3>("h4")) @[Datapath.scala 50:26]
    node _reg_io_data_T_1 = tail(_reg_io_data_T, 1) @[Datapath.scala 50:26]
    node _GEN_0 = mux(_T_2, _reg_io_data_T_1, UInt<1>("h0")) @[Datapath.scala 49:8 Datapath.scala 50:20 Datapath.scala 54:20]
    node _GEN_1 = mux(_T_1, alu.io_out, _GEN_0) @[Datapath.scala 45:8 Datapath.scala 46:20]
    node _GEN_2 = mux(_T, dmem.io_Dout, _GEN_1) @[Datapath.scala 40:8 Datapath.scala 41:20]
    node _alu_io_in_A_T = and(cu.io_bformat, Bran.io_br_taken) @[Datapath.scala 61:41]
    node _alu_io_in_A_T_1 = or(_alu_io_in_A_T, cu.io_jalformate) @[Datapath.scala 61:62]
    node _alu_io_in_A_T_2 = or(_alu_io_in_A_T_1, cu.io_jalrformate) @[Datapath.scala 61:82]
    node _alu_io_in_A_T_3 = mux(_alu_io_in_A_T_2, pc_r, reg.io_rs1out) @[Datapath.scala 61:25]
    node _T_3 = bits(cu.io_in, 14, 12) @[Datapath.scala 65:22]
    node _T_4 = eq(_T_3, UInt<2>("h3")) @[Datapath.scala 65:30]
    node _GEN_3 = mux(_T_4, cu.io_fun_3, UInt<1>("h0")) @[Datapath.scala 66:9 Datapath.scala 67:23 Datapath.scala 64:22]
    node _GEN_4 = mux(cu.io_rformat, reg.io_rs2out, cu.io_imm) @[Datapath.scala 82:30 Datapath.scala 83:24 Datapath.scala 87:22]
    node _T_5 = eq(cu.io_Wr_back, UInt<1>("h0")) @[Datapath.scala 91:24]
    node _T_6 = eq(cu.io_Wr_back, UInt<1>("h1")) @[Datapath.scala 95:31]
    node _T_7 = eq(cu.io_Wr_back, UInt<2>("h2")) @[Datapath.scala 99:31]
    node _io_out_T = add(pc_r, UInt<3>("h4")) @[Datapath.scala 101:21]
    node _io_out_T_1 = tail(_io_out_T, 1) @[Datapath.scala 101:21]
    node _GEN_5 = mux(_T_7, _io_out_T_1, UInt<1>("h0")) @[Datapath.scala 100:8 Datapath.scala 101:15 Datapath.scala 105:15]
    node _GEN_6 = mux(_T_6, alu.io_out, _GEN_5) @[Datapath.scala 96:8 Datapath.scala 97:15]
    node _GEN_7 = mux(_T_5, dmem.io_Dout, _GEN_6) @[Datapath.scala 92:8 Datapath.scala 93:15]
    io_Pcout <= pc_r @[Datapath.scala 29:17]
    io_out <= _GEN_7
    pc.clock <= clock
    pc.reset <= reset
    im.clock <= clock
    im.reset <= reset
    im.io_addr <= pc_r @[Datapath.scala 35:13]
    reg.clock <= clock
    reg.reset <= reset
    reg.io_ren <= cu.io_Wr_en @[Datapath.scala 63:19]
    reg.io_data <= _GEN_2
    reg.io_rs1 <= cu.io_rs1 @[Datapath.scala 56:19]
    reg.io_rs2 <= cu.io_rs2 @[Datapath.scala 57:19]
    reg.io_rd <= cu.io_rd @[Datapath.scala 58:18]
    cu.clock <= clock
    cu.reset <= reset
    cu.io_in <= im.io_inst @[Datapath.scala 36:17]
    cu.io_btake <= Bran.io_br_taken @[Datapath.scala 76:20]
    alu.clock <= clock
    alu.reset <= reset
    alu.io_in_A <= _alu_io_in_A_T_3 @[Datapath.scala 61:20]
    alu.io_in_B <= _GEN_4
    alu.io_aluop <= cu.io_aluop @[Datapath.scala 59:21]
    dmem.clock <= clock
    dmem.reset <= reset
    dmem.io_Wr_en <= cu.io_mem_wr_en @[Datapath.scala 70:22]
    dmem.io_address <= alu.io_out @[Datapath.scala 71:25]
    dmem.io_datain <= reg.io_rs2out @[Datapath.scala 72:24]
    dmem.io_fun3 <= _GEN_3
    Bran.clock <= clock
    Bran.reset <= reset
    Bran.io_fnct3 <= cu.io_bran_fn3 @[Datapath.scala 75:22]
    Bran.io_branch <= cu.io_bformat @[Datapath.scala 79:24]
    Bran.io_arg_x <= reg.io_rs1out @[Datapath.scala 77:22]
    Bran.io_arg_y <= reg.io_rs2out @[Datapath.scala 78:22]
    pc_r <= mux(reset, UInt<32>("h0"), _pc_r_T_2) @[Datapath.scala 22:25 Datapath.scala 22:25 Datapath.scala 28:12]

  module top :
    input clock : Clock
    input reset : UInt<1>
    output io_out : UInt<32>

    inst datapa of Datapath @[Topm.scala 11:20]
    inst sync of InstMem @[Topm.scala 12:18]
    io_out <= datapa.io_out @[Topm.scala 16:9]
    datapa.clock <= clock
    datapa.reset <= reset
    datapa.io_insin <= sync.io_inst @[Topm.scala 15:19]
    sync.clock <= clock
    sync.reset <= reset
    sync.io_addr <= datapa.io_Pcout @[Topm.scala 14:15]

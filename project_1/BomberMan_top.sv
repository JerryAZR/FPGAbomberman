module BomberMan_top( 	input               CLOCK_50,
						input        [3:0]  KEY,          //bit 0 is set up as Reset
						input 		 [15:0] SW,
						output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
						// VGA Interface 
						output logic [7:0]  VGA_R,        //VGA Red
											 VGA_G,        //VGA Green
											 VGA_B,        //VGA Blue
						output logic        VGA_CLK,      //VGA Clock
											 VGA_SYNC_N,   //VGA Sync signal
											 VGA_BLANK_N,  //VGA Blank signal
											 VGA_VS,       //VGA virtical sync signal
											 VGA_HS,       //VGA horizontal sync signal
						// CY7C67200 Interface
						inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
						output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
						output logic        OTG_CS_N,     //CY7C67200 Chip Select
											 OTG_RD_N,     //CY7C67200 Write
											 OTG_WR_N,     //CY7C67200 Read
											 OTG_RST_N,    //CY7C67200 Reset
						input               OTG_INT,      //CY7C67200 Interrupt
						// SDRAM Interface for Nios II Software
						output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
						inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
						output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
						output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
						output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
											 DRAM_CAS_N,   //SDRAM Column Address Strobe
											 DRAM_CKE,     //SDRAM Clock Enable
											 DRAM_WE_N,    //SDRAM Write Enable
											 DRAM_CS_N,    //SDRAM Chip Select
											 DRAM_CLK      //SDRAM Clock
					);
					
	
    logic Reset_h, Clk, ROM_Clk;
	logic [15:0] keyA, keyB, keyC;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
					
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
    nios_system nios_system(
							.clk_clk(Clk),         
                            .reset_reset_n(1'b1),    // Never reset NIOS
                            .keya_export(keyA[7:0]), 
							.keyb_export(keyA[15:8]),
							.keyc_export(keyB[7:0]),
							.keyd_export(keyB[15:8]),
							.keye_export(keyC[7:0]),
							.keyf_export(keyC[15:8]),
                            .otg_hpi_address_export(hpi_addr),
                            .otg_hpi_data_in_port(hpi_data_in),
                            .otg_hpi_data_out_port(hpi_data_out),
                            .otg_hpi_cs_export(hpi_cs),
                            .otg_hpi_r_export(hpi_r),
                            .otg_hpi_w_export(hpi_w),
                            .otg_hpi_reset_export(hpi_reset),
							.sdram_wire_addr(DRAM_ADDR), 
                            .sdram_wire_ba(DRAM_BA),   
                            .sdram_wire_cas_n(DRAM_CAS_N),
                            .sdram_wire_cke(DRAM_CKE),  
                            .sdram_wire_cs_n(DRAM_CS_N), 
                            .sdram_wire_dq(DRAM_DQ),   
                            .sdram_wire_dqm(DRAM_DQM),  
                            .sdram_wire_ras_n(DRAM_RAS_N),
                            .sdram_wire_we_n(DRAM_WE_N), 
                            .sdram_clk_clk(DRAM_CLK),
							.rom_clk_clk(ROM_Clk)
    );
    
	// Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
							.Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     

	vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));

	logic [7:0] p1move, p2move;
	logic p1bomb, p2bomb, p1gain, p2gain, p1red, p2red;
	logic [9:0] DrawX, DrawY;
	logic is_Char1, is_Char2, MapWE, dir1, dir2, WE0, WE1, WE2, WE3, WE4, WE5;
	logic [9:0] Char1_X_Pos, Char1_Y_Pos, Char2_X_Pos, Char2_Y_Pos;
	logic [7:0] Item_ID, id1, id2, buff_id1, buff_id2;
	logic IDcheck1up, IDcheck1down, IDcheck1left, IDcheck1right;
	logic IDcheck2up, IDcheck2down, IDcheck2left, IDcheck2right;
	logic [23:0] defaultRGB;
	logic [7:0] MapWriteAddr, MapWriteData;
	logic [11:0] timer;
	logic [7:0] addr0, addr1, addr2, addr3, data0, data1, data2, data3;
	logic [7:0] p1score, p2score;
	logic [3:0] randhex, randhex2;
	logic [9:0] Char1_step, Char2_step;
	logic [1:0] bomb1_size, bomb2_size;
	logic [9:0] delay1, delay2, cooldown1, cooldown2;
	logic [3:0] Char1_X_Map_Pos, Char1_Y_Map_Pos;	
	logic [3:0] Char2_X_Map_Pos, Char2_Y_Map_Pos;
	
	parameter [7:0] path = 8'h80;
	
	assign Char2_X_Map_Pos = {(Char2_X_Pos[8:5] + {{3{1'b0}},Char2_X_Pos[4]})};
	assign Char2_Y_Map_Pos = {(Char2_Y_Pos[8:5] + {{3{1'b0}},Char2_Y_Pos[4]})};

	
	assign Char1_X_Map_Pos = {(Char1_X_Pos[8:5] + {{3{1'b0}},Char1_X_Pos[4]})};
	assign Char1_Y_Map_Pos = {(Char1_Y_Pos[8:5] + {{3{1'b0}},Char1_Y_Pos[4]})};

    VGA_controller vga_controller_instance(.Reset(Reset_h), .Clk(CLOCK_50),
	.VGA_HS, .VGA_VS, .VGA_CLK, .VGA_BLANK_N, .VGA_SYNC_N, .DrawX, .DrawY);
    
	movement mv(.*);
	
	timer_64Hz timer0(.Clk(CLOCK_50), .timer(timer), .slow_clk(VGA_VS));
	
	buff p1buff(.Clk(CLOCK_50), .Reset(Reset_h), .player(1'b0), .id(buff_id1), .randhex(randhex2), .WE(WE4), 
	.step(Char1_step), .size(bomb1_size), .delay(delay1), .cooldown(cooldown1), .frame_clk(VGA_VS));
	Map map_p1buff(.waddr(MapWriteAddr), .raddr({Char1_Y_Map_Pos, Char1_X_Map_Pos}), .wdata(MapWriteData),.q(buff_id1), .we(MapWE), .clk(ROM_Clk));
	
	buff p2buff(.Clk(CLOCK_50), .Reset(Reset_h), .player(1'b1), .id(buff_id2), .randhex(randhex2), .WE(WE5), 
	.step(Char2_step), .size(bomb2_size), .delay(delay2), .cooldown(cooldown2), .frame_clk(VGA_VS));
	Map map_p2buff(.waddr(MapWriteAddr), .raddr({Char2_Y_Map_Pos, Char2_X_Map_Pos}), .wdata(MapWriteData),.q(buff_id2), .we(MapWE), .clk(ROM_Clk));
	
    // Player1 module
    Character Char_instance1(.Clk(CLOCK_50), .Reset(Reset_h), .frame_clk(VGA_VS),
	.DrawX, .DrawY, .is_Char(is_Char1), .move(p1move), .dir(dir1), .Step(Char1_step),
	.Char_X_Pos(Char1_X_Pos), .Char_Y_Pos(Char1_Y_Pos), .X_Reset(10'd32), .Y_Reset(10'd32),
	.upID(IDcheck1up), .downID(IDcheck1down), .leftID(IDcheck1left), .rightID(IDcheck1right));
	
	// Player2 module
	Character Char_instance2(.Clk(CLOCK_50), .Reset(Reset_h), .frame_clk(VGA_VS),
	.DrawX, .DrawY, .is_Char(is_Char2), .move(p2move), .dir(dir2), .Step(Char2_step),
	.Char_X_Pos(Char2_X_Pos), .Char_Y_Pos(Char2_Y_Pos), .X_Reset(10'd416), .Y_Reset(10'd416),
	.upID(IDcheck2up), .downID(IDcheck2down), .leftID(IDcheck2left), .rightID(IDcheck2right));
    
	// place bombs
	BombManager BM(.Clk(CLOCK_50), .Reset(Reset_h), .p1bomb, .p2bomb, .timer(timer[11:2]), .cooldown1, .cooldown2, .delay1, .delay2,
	.Char1_X_Pos, .Char1_Y_Pos, .Char2_X_Pos, .Char2_Y_Pos, .id1, .id2, .p1gain, .p2gain, .p1size(bomb1_size), .p2size(bomb2_size),
	.WE0, .WE1, .WE2, .WE3, .addr0, .addr1, .addr2, .addr3, .data0, .data1, .data2, .data3, .randhex);
	
	Map map_p1bomb(.waddr(MapWriteAddr), .raddr(addr0), .wdata(MapWriteData),.q(id1), .we(MapWE), .clk(ROM_Clk));
	
	Map map_p2bomb(.waddr(MapWriteAddr), .raddr(addr1), .wdata(MapWriteData),.q(id2), .we(MapWE), .clk(ROM_Clk));
	//
	Map map_VGA(.waddr(MapWriteAddr), .raddr({DrawY[8:5], DrawX[8:5]}), .wdata(MapWriteData),.q(Item_ID), .we(MapWE),
	.clk(ROM_Clk));
	
	MapEditor(.WE0, .WE1, .WE2, .WE3, .WE4, .WE5, .addr0, .addr1, .addr2, .addr3, .addr4({Char1_Y_Map_Pos, Char1_X_Map_Pos}), .addr5({Char2_Y_Map_Pos, Char2_X_Map_Pos}),
	.data0, .data1, .data2, .data3, .data4(path), .data5(path), .Clk(CLOCK_50), .Reset(Reset_h), .ROM_Clk, .WE(MapWE), .MapWriteAddr, .MapWriteData);
		
	// Check neighbors
	NeighborID P1neighbor(.waddr(MapWriteAddr), .wdata(MapWriteData), .X_Pos(Char1_X_Pos), .Y_Pos(Char1_Y_Pos), .Step(Char1_step),
	.we(MapWE), .clk(ROM_Clk), .up(IDcheck1up), .down(IDcheck1down), .left(IDcheck1left), .right(IDcheck1right));
	
	NeighborID P2neighbor(.waddr(MapWriteAddr), .wdata(MapWriteData), .X_Pos(Char2_X_Pos), .Y_Pos(Char2_Y_Pos), .Step(Char2_step),
	.we(MapWE), .clk(ROM_Clk), .up(IDcheck2up), .down(IDcheck2down), .left(IDcheck2left), .right(IDcheck2right));
	
	ShapeMapper shape(.raddr({DrawX[4:0], DrawY[4:0]}), .clk(ROM_Clk), .Item_ID, .q(defaultRGB));
	
	hit turnred(.Clk(CLOCK_50), .Reset(Reset_h), .p1gain, .p2gain, .timer(timer[11:2]), .p1red, .p2red);
    color_mapper color_instance(.*);
	
	ScoreBoard(.Clk(CLOCK_50), .Reset(Reset_h), .p1gain, .p2gain, .p1score, .p2score);
	
	RNG random(.Clk(CLOCK_50), .Reset(Reset_h), .randhex, .seed(SW));
	RNG another_rng(.Clk(CLOCK_50), .Reset(Reset_h), .randhex(randhex2), .seed(~SW));
	// For test only
	parameter [6:0] P = 7'b0001100;
	HexDriver hex_inst_0 (p2score[3:0], HEX0);
    HexDriver hex_inst_1 (p2score[7:4], HEX1);
	HexDriver hex_inst_2 (4'h2, HEX2);
	HexDriver hex_inst_3 (P, HEX3);
//	assign HEX3 = P;
	
	HexDriver hex_inst_4 (p1score[3:0], HEX4);
    HexDriver hex_inst_5 (p1score[7:4], HEX5);
	HexDriver hex_inst_6 (4'h1, HEX6);
	HexDriver hex_inst_7 (P, HEX7);
//	assign HEX7 = P;
    
endmodule

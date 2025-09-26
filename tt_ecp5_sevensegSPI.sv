`default_nettype none

module tt_ecp5_sevensegSPI (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    spi_slave_sevenseg top(.sclk(ui_in[0]), .mosi(ui_in[1]), .ss(ui_in[2]), .rst_n(rst_n), .out(uo_out[7:0])); 

endmodule

module spi_slave_sevenseg (
    input wire sclk,
    input wire mosi,
    input wire ss,
    input wire rst_n, // Active-low reset
    output reg [7:0] out
);

    reg [5:0] shift_reg; // 6-bit shift register (2-bit command + 4-bit data)
    reg [2:0] bit_count; // Track received bits
    reg [6:0] segment_data;
    reg data_ready;
    reg update_display;

    always @(posedge sclk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count <= 0;
            shift_reg <= 0;
            data_ready <= 0;
        end else begin
            if (ss) begin
                bit_count <= 0;
                data_ready <= 0;
            end else begin
                shift_reg <= {shift_reg[4:0], mosi};

                if (bit_count == 5) begin 
                    bit_count <= 0;
                    data_ready <= 1;
                end else begin
                    data_ready <= 0;
                    bit_count <= bit_count + 1;
                end
            end
        end
    end

    always @(negedge sclk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 8'b0;
        end else begin
            if (data_ready) begin
                case (shift_reg[3:0])
                    4'h0: segment_data = 7'b0111111;
                    4'h1: segment_data = 7'b0000110;
                    4'h2: segment_data = 7'b1011011;
                    4'h3: segment_data = 7'b1001111;
                    4'h4: segment_data = 7'b1100110;
                    4'h5: segment_data = 7'b1101101;
                    4'h6: segment_data = 7'b1111101;
                    4'h7: segment_data = 7'b0000111;
                    4'h8: segment_data = 7'b1111111;
                    4'h9: segment_data = 7'b1101111;
                    4'hA: segment_data = 7'b1110111;
                    4'hB: segment_data = 7'b1111100;
                    4'hC: segment_data = 7'b0111001;
                    4'hD: segment_data = 7'b1011110;
                    4'hE: segment_data = 7'b1111001;
                    4'hF: segment_data = 7'b1110001;
                    default: segment_data = 7'b0000000;
                endcase
                
                case (shift_reg[5:4])
                    2'b10: begin // Display data
                        out[6:0] <= segment_data;
                        out[7] <= 0; // Turn off decimal point
                    end
                    2'b01: begin // Display data with decimal point on
                        out[6:0] <= segment_data;
                        out[7] <= 1; // Turn on decimal point
                    end
                    default: begin
                        out[6:0] <= 7'b0000000; // Switch off display for malformed commands
                        out[7] <= 1; // But switch on the decimal point
                    end
                endcase
            end
        end
    end
endmodule
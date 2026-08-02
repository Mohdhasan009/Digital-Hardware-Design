#include <stdio.h>
#include <stdbool.h>
#include "xaxidma.h"
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include <stdlib.h>
#include <complex.h>
#include <time.h>
#include <xtime_l.h>
#include <math.h>

#define N 8

//vector which contains the positions of data shuffle
const int rev8_in[N] = {0, 4, 2, 6, 1, 5, 3, 7};

const float complex W[N/2] = {1-0*I, 0.7071067811865476-0.7071067811865475*I, 0.0-1*I, -0.7071067811865475-0.7071067811865476*I};

void bitreverse(int rev8[N] , float complex dataIn[N], float complex dataOut[N])
{
    bit_reversal: for (int i = 0 ; i < N ; i++)
    {
        dataOut[i] = dataIn[rev8[i]];
    }
}

void FFT_stages(float complex FFT_input[N], float complex FFT_output[N])
{
    float complex temp1[N], temp2[N];

    //stage1:
			for (int i = 0 ; i < N ; i=i+2)
    {
        temp1[i] = FFT_input[i] + FFT_input[i+1];
        temp1[i+1] = FFT_input[i] - FFT_input[i+1];
    }

    //stage2:
		for (int i = 0 ; i < N ; i=i+4)
    {
        for (int j = 0; j < 2; ++j)
        {
            temp2[i+j] = temp1[i+j] + W[2*j]*temp1[i+j+2];
            temp2[i+2+j] = temp1[i+j] - W[2*j]*temp1[i+j+2];
        }
    }

    //stage3:
			for (int i = 0 ; i < N/2 ; i++)
    {
        FFT_output[i] = temp2[i] + W[i]*temp2[i+4];
        FFT_output[i+4] = temp2[i] - W[i]*temp2[i+4];
    }
}

XAxiDma AxiDma;

int init_DMA() //this function initializes the DMA instance with required configurations
{
    XAxiDma_Config *CfgPtr;

    int status;

    CfgPtr = XAxiDma_LookupConfig(XPAR_AXI_DMA_0_DEVICE_ID); //extracts the configuration settings of DMA
    //the XPAR_AXI_DMA_0_DEVICE_ID is defined in xparameters.h file

    if (!CfgPtr)
    {
        xil_printf("No config found for %d\r\n", XPAR_AXI_DMA_0_DEVICE_ID);
        return XST_FAILURE;
    }

    status = XAxiDma_CfgInitialize(&AxiDma, CfgPtr); //initializes the DMA instance with above settings

    if (status != XST_SUCCESS)
    {
        xil_printf("DMA Initialization Failed. Return Status: %d\r\n", status);
        return XST_FAILURE;
    }

    if(XAxiDma_HasSg(&AxiDma)) //check whether DMA is in scatter gather mode. If yes, return error
    {
        xil_printf("Device configuration as SG mode\r\n");
        return XST_FAILURE;
    }

    return XST_SUCCESS;
}

u32 checkIdle(u32 baseAddress, u32 offset) //this function is defined to check whether DMA is busy or not
{
    //offset = 0x4 to check for DMA to FIFO transaction channel

    //offset = 0x34 to check for FIFO to DMA transaction channel
    u32 status;

    status = (XAxiDma_ReadReg(baseAddress, offset)) & XAXIDMA_IDLE_MASK; //XAXIDMA_IDLE_MASK;

    return status;
}

int main()
{
	xil_printf("\r\n***Entering main function***\r\n");
	init_platform();

	xil_printf("\r\nMAIN STARTED\r\n");
    // to store the time at which certain processes starts and ends
    XTime tprocessorStart , tprocessorend;
    XTime tfpgaStart , tfpgaend;

    const float complex FFT_input[N] = {11+23*I,32+10*I,91+94*I,15+69*I,47+96*I,44+12*I,96+17*I,49+58*I}; // input to the FFT in PS and PL

    float complex FFT_output_PS[N];
    float complex FFT_rev[N];

    //-------------------- PS PART --------------------//



    XTime_GetTime(&tprocessorStart); // getting the time before FFT is Done in PS
    bitreverse(rev8_in , FFT_input, FFT_rev);
    FFT_stages(FFT_rev, FFT_output_PS);
    XTime_GetTime(&tprocessorend); // getting the time after FFT is done in PS



    int status_dma = init_DMA(); //initializing the DMA

    if (status_dma != XST_SUCCESS)
    {
        xil_printf("Couldn't initialize DMA\r\n");
        return XST_FAILURE;
    }


    float complex RX_PNTR[N]; // to store the output from the PL

    bool err_flag = false; //error flag to check for mismatch between transmitted and received data


    Xil_DCacheFlushRange((UINTPTR)FFT_input, (sizeof(float complex)*N)); //cache flush to write back the data in the DDR memory
    Xil_DCacheFlushRange((UINTPTR)RX_PNTR, (sizeof(float complex)*N));

    //status = 2 indicates idle and status = 0 indicates idle
    xil_printf("\nDMA status before transfer\r\nDMA to Device: %d, Device to DMA:%d\r\n",
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x4),
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x34));

    xil_printf("\rStarting Data Transfer-------------->>>>>>>>\r\n");

    int status_transfer;

    XTime_GetTime(&tfpgaStart); // getting the time before FFT is Done in PL

    status_transfer = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)RX_PNTR, (sizeof(float complex)*N), XAXIDMA_DEVICE_TO_DMA);
    //transferring data from DDR to FFT.

    if (status_transfer != XST_SUCCESS)
    {
        xil_printf("Writing data to FFT_IP via DMA failed\r\n");
    }

    xil_printf("DMA status between transfer\nDMA to Device status: %d, Device to DMA status: %d\r\n",
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x4),
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x34));

    status_transfer = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)FFT_input, (sizeof(float complex)*N), XAXIDMA_DMA_TO_DEVICE);
    //receiving data from FFT in DDR.

    if (status_transfer != XST_SUCCESS)
    {
        xil_printf("Reading data from FFT via DMA failed\r\n");
    }

    xil_printf("DMA status after transfer\nDMA to Device status: %d, Device to DMA status: %d\r\n",
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x4),
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x34));

    XTime_GetTime(&tfpgaend); // getting the time before FFT is Done in PL

    int status = checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x4); //DMA to device

    while(status != 2)
    {
        status = checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x4);
        //xil_printf("status value : %d \n" , status);
    }

    status = checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x34); //Device to DMA

    while(status != 2)
    {
        status = checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x34);
    }

    xil_printf("DMA status after transfer\nDMA to Device status: %d, Device to DMA status: %d\r\n",
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x4),
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x34));

    xil_printf("\nComparing software FFT outputs and hardware FFT outputs via DMA \r\n");


    int j = 0;
    printf("size of float complex : %d \n" , sizeof(float complex));
    for (j = 0 ; j < N ; j++)
    {
        printf("PS Output : %f + I%f , PL output : %f + I%f \n ",
               crealf(FFT_output_PS[j]),
               cimagf(FFT_output_PS[j]),
               crealf(RX_PNTR[j]),
               cimagf(RX_PNTR[j]));
        //printing the output of PS and PL

        float diff1 = abs(crealf(FFT_output_PS[j]) - crealf(RX_PNTR[j]));
        float diff2 = abs(cimagf(FFT_output_PS[j]) - cimagf(RX_PNTR[j]));

        if ( diff1 >= 0.0001 && diff2 >= 0.0001)
        {
            err_flag = true; //error flag asserted for any mismatch
            break;
        }
    }


    if (err_flag)
        xil_printf("Data Mismatch found at %d. Transmitted Data: %d. Received Data: %d\r\n", j , FFT_output_PS[j], RX_PNTR[j]);
    else
        xil_printf("\nDMA ran successfully!! :)");

    xil_printf("\n----------TIME COMPARISION------------------\n");


    // here we are calculating the time it took for PS and PL to execute a data
    float time_processor = 0;
    time_processor = (float)1.0 * (tprocessorend - tprocessorStart) / (COUNTS_PER_SECOND/1000000);
    xil_printf("time for PS : %d\n" , time_processor);

    float time_fpga = 0;
    time_fpga = (float)1.0 * (tfpgaend - tfpgaStart) / (COUNTS_PER_SECOND/1000000);
    xil_printf("time for PL : %d\n" , time_fpga);

     cleanup_platform();
    return XST_SUCCESS;

}


#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "platform.h"
#include "xparameters.h"
#include "xil_printf.h"
#include "xil_cache.h"
#include "xstatus.h"
#include "xaxidma.h"

#define FIFO_DEPTH 128

XAxiDma AxiDma;

int init_DMA()
{
    XAxiDma_Config *CfgPtr;
    int status;

    CfgPtr = XAxiDma_LookupConfig(XPAR_AXI_DMA_0_DEVICE_ID);

    if (!CfgPtr)
    {
        xil_printf("No config found for %d\r\n", XPAR_AXI_DMA_0_DEVICE_ID);
        return XST_FAILURE;
    }

    status = XAxiDma_CfgInitialize(&AxiDma, CfgPtr);

    if (status != XST_SUCCESS)
    {
        xil_printf("DMA Initialization Failed. Return Status: %d\r\n", status);
        return XST_FAILURE;
    }

    if (XAxiDma_HasSg(&AxiDma))
    {
        xil_printf("Device configuration as SG mode\r\n");
        return XST_FAILURE;
    }

    return XST_SUCCESS;
}

u32 checkIdle(u32 baseAddress, u32 offset)
{
    u32 status;

    status = (XAxiDma_ReadReg(baseAddress, offset)) & XAXIDMA_IDLE_MASK;

    return status;
}
	int TX_PNTR[FIFO_DEPTH];
    int RX_PNTR[FIFO_DEPTH];
int main()
{
    init_platform();

    xil_printf("\r\n********Entering main function********\r\n");

    int status_dma = init_DMA();

    if (status_dma != XST_SUCCESS)
    {
        xil_printf("Couldn't initialize DMA\r\n");
        cleanup_platform();
        return XST_FAILURE;
    }



    bool err_flag = false;

    for (int i = 0; i < FIFO_DEPTH; i++)
        TX_PNTR[i] = 2 * i;

    Xil_DCacheFlushRange((UINTPTR)TX_PNTR, sizeof(int) * FIFO_DEPTH);
    Xil_DCacheInvalidateRange((UINTPTR)RX_PNTR, sizeof(int) * FIFO_DEPTH);

    xil_printf("\nDMA status before transfer\r\nDMA to Device: %d, Device to DMA: %d\r\n",
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x4),
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x34));

    xil_printf("\rStarting Data Transfer----------->>>>>>>\r\n");

    int status_transfer;

    status_transfer = XAxiDma_SimpleTransfer(&AxiDma,
                                             (UINTPTR)RX_PNTR,
                                             sizeof(int) * FIFO_DEPTH,
                                             XAXIDMA_DEVICE_TO_DMA);

    if (status_transfer != XST_SUCCESS)
    {
        xil_printf("Reading data from FIFO via DMA failed\r\n");
    }

    xil_printf("DMA status between transfer\nDMA to Device status: %d, Device to DMA status: %d\r\n",
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x4),
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x34));

    status_transfer = XAxiDma_SimpleTransfer(&AxiDma,
                                             (UINTPTR)TX_PNTR,
                                             sizeof(int) * FIFO_DEPTH,
                                             XAXIDMA_DMA_TO_DEVICE);

    if (status_transfer != XST_SUCCESS)
    {
        xil_printf("Writing data to FIFO via DMA failed\r\n");
    }

    xil_printf("DMA status after transfer\nDMA to Device status: %d, Device to DMA status: %d\r\n",
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x4),
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x34));

    int status = checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x4);

    while (status != 2)
    {
        status = checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x4);
    }

    status = checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x34);

    while (status != 2)
    {
        status = checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x34);
    }

    xil_printf("DMA status after waiting\nDMA to Device status: %d, Device to DMA status: %d\r\n",
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x4),
               checkIdle(XPAR_AXI_DMA_0_BASEADDR, 0x34));

    Xil_DCacheInvalidateRange((UINTPTR)RX_PNTR, sizeof(int) * FIFO_DEPTH);

    xil_printf("\nComparing data transmitted to FIFO and read from FIFO via DMA \r\n");

    int j = 0;

    for (j = 0; j < FIFO_DEPTH; j++)
    {
        if (TX_PNTR[j] != RX_PNTR[j])
        {
            err_flag = true;
            break;
        }
    }

    if (err_flag)
        xil_printf("Data Mismatch found at %d. Transmitted Data: %d. Received Data: %d\r\n",
                   j,
                   TX_PNTR[j],
                   RX_PNTR[j]);
    else
        xil_printf("DMA ran successfully!! :)\n");

    cleanup_platform();
    return XST_SUCCESS;
}

#include "config.h"

ENTRY(_start)

//Define the flash max size
__max_flash_size = FLASH_CODE_SIZE;

__base = 0x10000000;

// retention RAM
__cache_stack_vma   = 0x10600;  //for loader
__cache_stack_size  = 512;      //for loader
__stack_vma         = 0x10800;
__stack_ram_size    = 1k;
__heap_vma          = 0x10c00;
__heap_ram_size     = 12k;
__comm_vma          = 0x13c00;
__comm_ram_size     = 40k;
__data_vma          = 0x1dc00;
__data_ram_size     = 25k;


// non retention RAM
__bram_vma          = 0x24000;
__bram_ram_size     = 48k;

__cram_a2dp_vma     = 0x30000;      //a2dp数据缓存
__cram_dec_vma      = 0x35800;      //音乐解码缓存
__cram_ldac_vma     = 0x35800;

__lhdc_ram_vma      = 0x35800;
__lhdc_ram_size     = 110k;
__lhdc_com_ram_size = 6k;           //LHDC变量区公共部分

__cram_dnn_comm_vma = 0x30000;      //dnn代码区
__cram_dnn_vma      = 0x35000;      //dnn变量区

__cram_dnn_pro_comm_vma = 0x30000;  //dnn_pro代码区
__cram_dnn_pro_vma      = 0x35000;  //dnn_pro变量区

__cram_aiaec_dnn_comm_vma = 0x30000;  //aiaec_dnn代码区
__cram_aiaec_dnn_vma      = 0x35000;  //aiaec_dnn变量区

__cram_sndp_comm_vma = 0x30000;     //sndp代码区
__cram_sndp_vma      = 0x36800;     //sndp变量区

__cram_dmdnn_comm_vma = 0x30000;    //dmdnn代码区
__cram_dmdnn_vma      = 0x37000;    //dmdnn变量区

__cram_ldmdnn_comm_vma = 0x30000;    //dmdnn代码区
__cram_ldmdnn_vma      = 0x37000;    //dmdnn变量区

__cram_ains_comm_vma  = 0x30000;    //ains代码区
__cram_ains_vma       = 0x38800;    //ains变量区

__cram_agc_vma       = 0x3fa00;     //agc变量区

__nram_ttp_vma        = 0x30000;    //ttp音效变量区(4k)

__nram_vma          = 0x40000;      //npu
__aram_vma          = 0x100000;     //20k
__nrram_vma         = 0x105000;     //8k
__nrram_dec_comm_vma    = 0x105000; //解码代码区(8k)
__dram_vma          = 0x108000;     //17.25k
__eram_vma          = 0x107000;     //2.5k

#if ANC_ALG_AI_WN_DSP_FF_EN
__nram_audio_comm_vma = 0x40000;
__nram_audio_comm_len = 18k;        //音乐音效算法代码区
__nram_audio_len      = 16k;        //音乐音效算法变量区
__anc_alg_comm_len    = 8k;         //ANC算法代码区
__anc_alg_len         = 58k;        //ANC算法变量区
#elif ANC_ALG_AI_NPU_EN
//ANC算法使用NPU，ANC相关代码变量放cram
__nram_audio_comm_vma = 0x39800;
__nram_audio_comm_len = 0k;
__nram_audio_len      = 0k;
__anc_alg_comm_len    = 6k;
__anc_alg_len         = 20k;
#else
__nram_audio_comm_vma = 0x40000;
__nram_audio_comm_len = 20k;
__nram_audio_len      = 16k;
__anc_alg_comm_len    = 20k;
__anc_alg_len         = 44k;
#endif
__nram_audio_vma      = __nram_audio_comm_vma + __nram_audio_comm_len;
__anc_alg_comm_vma    = __nram_audio_vma + __nram_audio_len;
__anc_alg_vma         = __anc_alg_comm_vma + __anc_alg_comm_len;

__anc_tool_ram_vma    = 0x40000;    //ANC工具
__anc_tool_ram_len    = 100k;

MEMORY
{
    init                : org = __base,                 len = 512
    flash(rx)           : org = __base + 512,           len = __max_flash_size
    comm(rx)            : org = __comm_vma,             len = __comm_ram_size
    nrram_dec_comm(rx)  : org = __nrram_dec_comm_vma,   len = 8k
    boot                : org = __cache_stack_vma,      len = __cache_stack_size

    stack               : org = __stack_vma,            len = __stack_ram_size
    heap                : org = __heap_vma,             len = __heap_ram_size
    data                : org = __data_vma,             len = __data_ram_size
    bram                : org = __bram_vma,             len = __bram_ram_size

    aram                : org = __aram_vma,             len = 20k
    dram                : org = __dram_vma,             len = 0x4500
    nrram               : org = __nrram_vma,            len = 0x2000
    eram                : org = __eram_vma,             len = 0xa00

    //音乐缓存
    cram_a2dp           : org = __cram_a2dp_vma,        len = 22k
    cram_dec            : org = __cram_dec_vma,         len = 42k
    cram_ldac_comm(rx)  : org = __cram_ldac_vma,        len = 24k
    lhdc_ram            : org = __lhdc_ram_vma,         len = __lhdc_ram_size

    //通话缓存
    //dnn算法(0x30000~0x40000)
    cram_dnn_comm(rx)   : org = __cram_dnn_comm_vma,    len = 22k
    cram_dnn            : org = __cram_dnn_vma,         len = 0xa200
    //dnn_pro算法(0x30000~0x40000)
    cram_dnn_pro_comm(rx)   : org = __cram_dnn_pro_comm_vma,    len = 22k
    cram_dnn_pro            : org = __cram_dnn_pro_vma,         len = 0xa200
    //aiaec_dnn算法(0x30000~0x40000)
    cram_aiaec_dnn_comm(rx)   : org = __cram_aiaec_dnn_comm_vma, len = 22k
    cram_aiaec_dnn            : org = __cram_aiaec_dnn_vma,      len = 0xa200
    //sndp算法(0x30000~0x40000)
    cram_sndp_comm    	: org = __cram_sndp_comm_vma, 	len = 26k
    cram_sndp         	: org = __cram_sndp_vma,      	len = 0x9200
    //dmdnn算法(0x30000~0x40000)
    cram_dmdnn_comm(rx) : org = __cram_dmdnn_comm_vma,  len = 28k
    cram_dmdnn          : org = __cram_dmdnn_vma,       len = 0x8a00
    //ldmdnn算法(0x30000~0x40000)
    cram_ldmdnn_comm(rx) : org = __cram_ldmdnn_comm_vma,  len = 28k
    cram_ldmdnn          : org = __cram_ldmdnn_vma,       len = 0x8a00
    //ains算法(0x30000~0x36000)
    cram_ains_comm(rx)  : org = __cram_ains_comm_vma,   len = 14k
    cram_ains           : org = __cram_ains_vma,        len = 0x2200

    cram_agc            : org = __cram_agc_vma,         len = 0x600

    nram                : org = __nram_vma,             len = 100k

    //音乐音效算法
    nram_audio_comm(rx) : org = __nram_audio_comm_vma,  len = __nram_audio_comm_len
    nram_audio          : org = __nram_audio_vma,       len = __nram_audio_len

    //ANC算法
    anc_alg_comm(rx)    : org = __anc_alg_comm_vma,     len = __anc_alg_comm_len
    anc_alg             : org = __anc_alg_vma,          len = __anc_alg_len

    //ttp音效
    nram_ttp            : org = __nram_ttp_vma,         len = 4k

    anc_tool_ram        : org = __anc_tool_ram_vma,     len = __anc_tool_ram_len
}

SECTIONS
{
    .init : {
        *(.reset)
    } > init

    .data_cpu (NOLOAD) : {
        *(.buf.cpu_regs)
    } > boot

    .comm : {
        __vertor_vma = .;
        *(.vector)
        *(.com_text*)
        *debug.o(.rodata*)
        *(.com_rodata*)
        *(.data*)
        *(.sdata*)
        *(.plt)
        *(.text.wsbc.asm)
        . = ALIGN(512);
    } > comm AT > flash

    .cram_dnn_comm : {
        *(.dnn_rodata*)
        *(.dnn_text*)
        . = ALIGN(512);
    } > cram_dnn_comm AT > flash

    .cram_dnn_pro_comm : {
        *(.dnn_pro_rodata*)
        *(.dnn_pro_text*)
        . = ALIGN(512);
    } > cram_dnn_pro_comm AT > flash

    .cram_aiaec_dnn_comm : {
        *(.aiaec_dnn_rodata*)
        *(.aiaec_dnn_text*)
        . = ALIGN(512);
    } > cram_aiaec_dnn_comm AT > flash

    .cram_dmdnn_comm : {
        *(.dmdnn_rodata*)
        *(.dmdnn_text*)
        . = ALIGN(512);
    } > cram_dmdnn_comm AT > flash

    .cram_ldmdnn_comm : {
        *(.ldmdnn_rodata*)
        *(.ldmdnn_text*)
        . = ALIGN(512);
    } > cram_ldmdnn_comm AT > flash

    .cram_sndp_comm : {
        *(.sndp_comm_rodata*)
        *(.sndp_comm_text*)
        *(.sndp_rodata*)
        *(.sndp_text*)
        *(.sndp_fbdm_rodata*)
        *(.sndp_fbdm_text*)
        *(.sndp_dm_rodata*)
        *(.sndp_dm_text*)
        . = ALIGN(512);
    } > cram_sndp_comm AT > flash

    .cram_ains_comm : {
        *(.ains_rodata*)
        *(.ains_text*)
        . = ALIGN(512);
    } > cram_ains_comm AT > flash

    .cram_ldac_comm : {
        *(.text.ldac.dec.*)
        *(.rodata.ldac.dec.*)
        . = ALIGN(512);
    } > cram_ldac_comm AT > flash

    .lhdc_com_text __lhdc_ram_vma : {
        __code_start_lhdc_com_text = .;
        *(.text.lhdc.dec.*)
        *(.rodata.lhdc.dec.*)
        . = ALIGN(512);
        __code_end_lhdc_com_text = .;
    } > lhdc_ram AT > flash

    .lhdcv5_text __code_end_lhdc_com_text : {
        *(.lhdc_text.lhdcv5*)
        *(.lhdc_rodata.lhdcv5*)
        . = ALIGN(512);
        __code_end_lhdcv5_text = .;
    } > lhdc_ram AT > flash

    .lhdcv4_text __code_end_lhdc_com_text : {
        *(.lhdc_text.lhdcv3*)
        *(.lhdc_rodata.lhdcv3*)
        *(.lhdc_text.lhdcv4*)
        *(.lhdc_rodata.lhdcv4*)
        . = ALIGN(512);
        __code_end_lhdcv4_text = .;
    } > lhdc_ram AT > flash

    .nram_audio_comm : {
        *(.audio_rodata*)
        *(.audio_text*)
        . = ALIGN(512);
    } > nram_audio_comm AT > flash

    .anc_alg_comm : {
        *(.anc_rodata*)
        *(.anc_text*)
        *(.sndp_sae_rodata*)
        *(.sndp_sae_text*)
        . = ALIGN(512);
    } > anc_alg_comm AT > flash

#if !WARNING_WSBC_EN
    .nrram_dec_comm : {
        __code_start_btdec_com = .;
        *(.btdec*)
        . = ALIGN(512);
        __code_end_btdec_com = .;
    } > nrram_dec_comm AT > flash
#endif

    .anc_tool_code : {
        *(.anc_tool_rodata*)
        *(.anc_tool_text*)
        . = ALIGN(512);
    } > anc_tool_ram AT > flash

    .flash : {
        __code_start_stream = .;
        *(.com_stream.text*)
        . = ALIGN(512);
        __code_end_stream = .;

        __code_start_sniff = .;
        *(.sniff*)
        . = ALIGN(512);
        __code_end_sniff = .;

#if WARNING_WSBC_EN
        __code_start_btdec_com = .;
        *(.btdec*)
        . = ALIGN(512);
        __code_end_btdec_com = .;
#endif
        __code_start_usbdev = .;
        *(.usbdev*)
        . = ALIGN(512);
        __code_end_usbdev = .;

        __code_start_mp3dec = .;
        *(.mp3dec*)
        . = ALIGN(512);
        __code_end_mp3dec = .;

        __code_start_sbcdec = .;
        *(.sbcdec*)
        *(.sbc_com*)
        . = ALIGN(512);
        __code_end_sbcdec = .;

        __code_start_aacdec = .;
        *(.aacdec*)
        . = ALIGN(512);
        __code_end_aacdec = .;

        __code_start_wavdec = .;
        *(.wavdec*)
        . = ALIGN(512);
        __code_end_wavdec = .;

        __code_start_wmadec = .;
        *(.wmadec*)
        . = ALIGN(512);
        __code_end_wmadec = .;

        __code_start_apedec = .;
        *(.apedec*)
        . = ALIGN(512);
        __code_end_apedec = .;

        __code_start_flacdec = .;
        *(.flacdec*)
        . = ALIGN(512);
        __code_end_flacdec = .;

        __code_start_wma_rlc44q = .;
        *(.wma_huff_rlc44q_table)
        . = ALIGN(512);
        __code_end_wma_rlc44q = .;

        __code_start_wma_rlc44o = .;
        *(.wma_huff_rlc44o_table)
        . = ALIGN(512);
        __code_end_wma_rlc44o = .;

        __code_start_wma_rlc16 = .;
        *(.wma_huff_rlc16_table)
        . = ALIGN(512);
        __code_end_wma_rlc16 = .;

        __code_start_sleep = .;
        *(.saradc_text*)
        *(.sleep_text*)
        . = ALIGN(512);
        __code_end_sleep = .;

        __code_start_charge = .;
        *(.charge_text*)
        *(.text.charge)
        *(.text.bsp.tkey)
        *(.text.charge_box)
        . = ALIGN(512);
        __code_end_charge = .;

        __code_start_bt_voice = .;
        *(.bt_voice*)
        *(.sco_mic_dnr*)
        . = ALIGN(512);
        __code_end_bt_voice = .;

        __code_start_pwrsave = .;
        *(.text.pwroff*)
        . = ALIGN(512);
        __code_end_pwrsave = .;

        __code_start_bb_test = .;
        *(.bb_test*)
        *(.bb_test_rodata*)
        . = ALIGN(512);
        __code_end_bb_test = .;

         __code_start_piano = .;
        *(.piano_com*)
        . = ALIGN(512);
        __code_end_piano = .;

        __code_start_record = .;
        *(.com_rec*)
        . = ALIGN(512);
        __code_end_record = .;

        __code_start_mav = .;
        *(.text.mav*)
        *(.rodata.mav*)
        *(.text.pitch_shift*)
        *(.rodata.pitch_shift*)
        . = ALIGN(512);
        __code_end_mav = .;

        __code_start_update = .;
        *(.text.update*)
        . = ALIGN(512);
        __code_end_update = .;

        __code_start_huart = .;
        *(.com_huart*)
        . = ALIGN(512);
        __code_end_huart = .;

        __code_start_spdif = .;
        *(.spdif_text*)
        . = ALIGN(512);
        __code_end_spdif = .;

        __code_start_fota = .;
        *(.text.fot.cache*)
        . = ALIGN(512);
        __code_end_fota = .;

        __code_start_spiflash_id = .;
        *(.text.spiflash.*)
        . = ALIGN(512);
        __code_end_spiflash_id = .;

        __code_start_opus = .;
        *(.text.opus.asm)
        *(.text.opus.enc.asm)
        *(.text.opus.proc)
        *(.text.opus.enc.proc)
        *(.text.opus.ec_tell)
        *(.text.opus.enc.entenc)
        *(.text.opus.mathops)
        *(.rodata.opus*)
        . = ALIGN(512);
        __code_end_opus = .;

        __code_start_vad = .;
        *(.vad_text*)
        . = ALIGN(512);
        __code_end_vad = .;

        __code_start_asr = .;
        *(.ws_text*)
        . = ALIGN(512);
        __code_end_asr = .;

        __code_start_bts = .;
        *(.text.stk.tws.txreq*)
        *(.text.stk.l2cap.txreq*)
        . = ALIGN(512);
        *(.text.stk.tws.send*)
        . = ALIGN(512);
        *(.text.stk.tws.recv*)
        . = ALIGN(512);
        *(.text.stk.hci.tx*)
        . = ALIGN(512);
        *(.text.bts.hci.rx*)
        . = ALIGN(512);
        *(.text.stk.bt.acl.tx*)
        . = ALIGN(512);
        __code_end_bts = .;

        *(.irq_init.aligned)
        *(.text.qtest.process)
        *(.text.charge.process)
        *(.text.charge_box.process)
        *(.text.ab_mate.process)
        *(.text.func.bt.process)
        . = ALIGN(512);
        *(.text.ble.chmap*)
        . = ALIGN(512);

        *(.text*)
        *(.tuya_text.md5)
        *(.tuya_text.aes128_cbc)
        *(.rodata*)
        *(.srodata*)
        *(.rela*)
        LONG(0)
        . = ALIGN(512);

    } > flash

    .stack (NOLOAD) : {
        __irq_stack_start = .;
        . = 0x400;
        __irq_stack = .;
    } > stack
    __irq_stack_size = __irq_stack - __irq_stack_start;

    .heap (NOLOAD) : {
        *(.mem_heap)
    } > heap

    .bss (NOLOAD) : {
        __bss_start = .;
        *(COMMON)
        *(.bss*)
        *(.sbss*)
        *(.buf*)

        *(.btmem.stack.sdp)
        *(.btmem.stack.spp)
        *(.btmem.stack.l2cap)
        *(.btmem.stack.hid*)
        *(.qtest_buf)

        *(.dac_obuf*)
        *(.adc_buf*)
        *(.tkey_buf.debug)
        *(.wav_res_buf)
        *(.au0out_buf*)
        *(.sco_enc.obuf)
        __tuya_data_start = .;
        *(.tuya_data*)
        __tuya_data_end = .;
        *(.app.buf*)
#if GFPS_EN
        *(.gfps*)
        *(.ble_cache.sm*)
#endif
        *(.opus_buf.input)
        __bss_end = .;
    } > data

    __tuya_data_size = __tuya_data_end - __tuya_data_start;

    .bram __bram_vma (NOLOAD) : {
        *(.btmem.bthw)
        *(.btmem*)

        *(.ble_cache*)
        *(.ble_buf*)

        *(.fot_data.com*)
        *(.tuya_heap*)
        *(.dueros_dma_data*)
    } > bram

    .dec_dbg_btmen __bram_vma (NOLOAD) : {
        *(.mp3_dbg_buf*)
        *(.aac_dbg_buf*)
    } > bram

    .cram_a2dp __cram_a2dp_vma (NOLOAD) : {
        *(.a2dp_play*)
        *(.a2dp_cache1)
        . = 0x5800;
    } > cram_a2dp

    .cram_aac __cram_dec_vma (NOLOAD) : {
        *(.aac_buf*)
        *(.anc_dbg_buf)
        *(.codecs_buf.*)
        *(.music_buff*)
        *(.opus.buf*)
        __cram_aac_dec_size = ABSOLUTE(.) - __cram_dec_vma;
        __cram_anc_alg_start = MAX(__cram_aac_dec_size, 0x2A00);
        . = __cram_anc_alg_start;
        //以下是跟MP3提示音要同时跑的
#if VAD_MODE_SEL == VAD_MODE_1 && VAD_EN
        *(.vad.mic_buf*)
#endif
        *(.anc_buff*)
        *(.sndp_sae_buf.wind_detect_fffb.fft*)      //声加风噪anc硬件fft ram
#if !ANC_ALG_AI_NPU_EN
        . = 0xA800;
#else
        . = 0x4000;         //开了ANC AI算法，cram后面的26k给ANC算法放相关代码变量
#endif
    } > cram_dec

    .cram_music __cram_dec_vma (NOLOAD) : {
        . = 0x2000;
        *(.avio_buf)
        *(.diskio_buf)
        *(.pff.buf)
        *(.fname.buf)
        *(.pff_buf*)
        . = 0x2A00;
    } > cram_dec

    .cram_mp3enc __cram_dec_vma (NOLOAD) : {
        . = 0x2A00;
        *(.mp3_enc_buf.pcm)
        . = 0x3d00;
        *(.anc_res2_buf)
    } > cram_dec

    .cram_ldac __cram_dec_vma (NOLOAD) : {
        . = 0x6000;
        *(.ldac_buf.out)    //npu ram不支持dma
    } > cram_dec

    .cram_dnn __cram_dnn_vma (NOLOAD) : {
        *(.dnn_buf*)
        . = 0xa200;
    } > cram_dnn

    .cram_dnn_pro __cram_dnn_pro_vma (NOLOAD) : {
        *(.dnn_pro_buf*)
        . = 0xa200;
    } > cram_dnn_pro

    .cram_dueros __cram_dnn_vma (NOLOAD) : {
        . = 0x5800;
        *(.dueros_dma_malloc_memory*)
        *(.dueros_dma_queue_memory*)
    } > cram_dnn

    .cram_aiaec_dnn __cram_aiaec_dnn_vma (NOLOAD) : {
        *(.aiaec_dnn_buf*)
        . = 0xa200;
    } > cram_aiaec_dnn

    .cram_sndp __cram_sndp_vma (NOLOAD) : {
        *(.sndp_comm_buf*)
        *(.sndp_buf*)
        *(.sndp_fbdm_buf*)
        *(.sndp_dm_buf*)
        . = 0x9200;
    } > cram_sndp

    .cram_dmdnn __cram_dmdnn_vma (NOLOAD) : {
        *(.dmdnn_buf*)
        . = 0x8a00;
    } > cram_dmdnn

    .cram_ldmdnn __cram_dmdnn_vma (NOLOAD) : {
        *(.ldmdnn_buf*)
        . = 0x8a00;
    } > cram_ldmdnn

    .cram_ains __cram_ains_vma (NOLOAD) : {
        *(.ains_buf*)
        . = 0x2200;
    } > cram_ains

    cram_agc __cram_agc_vma (NOLOAD) : {
        *(.agc_buf*)
        . = 0x600;
    } > cram_agc

    .aram_aec __aram_vma (NOLOAD) : {
        *(.aec_buf)
    } > aram

    .fcc_buf __aram_vma (NOLOAD) : {
        . = 0x1000;
        *(.fcc_buf.huart)
        . = 0x4c00;
        *(.test_buf)
    } > aram

    .sbc_cache __aram_vma (NOLOAD) : {
        *(.sbc_cache_buf)
        . = 0x5000;
    } > aram

    .aram_music __aram_vma (NOLOAD) : {
        *(.mp3buf.dec)
        . = 0x1000;
        . = 0x2000;
        *(.udev_buf*)
        *(.usb_buf*)
        *(.mp3_id3_buf)
        *(.lrc_buf*)
        *(.fnav_buf)
        *(.pff.scan.tempbuf)
        . = 0x4800;
    } > aram

    .aram_msc_stm __aram_vma (NOLOAD) : {
        *(.stm_buf)
        . = 0x1000;
    } > aram

    .aram_sbcio __aram_vma (NOLOAD) : {
        . = 0x3800;
        *(.sbcio_buf*)
        . = 0x5000;
    } > aram

    .aram_aacio __aram_vma (NOLOAD) : {
        . = 0x3800;
        *(.aacio_buf*)
        *(.m4a_buf*)
        . = 0x5000;
    } > aram

    .aram_fmrx __aram_vma (NOLOAD) : {
        . = 0x2000;
        *(.fmrx_cb_buf)
    } > aram

    .aram_opus __aram_vma (NOLOAD) : {
        . = 0x3800;
        *(.opus_buf.dec*)
        . = 0x5000;
    } > aram

    .dram_upd __dram_vma (NOLOAD) : {
        . = 0x3800;
        *(.upd_ota*)
        *(.upd_buf*)
        . = 0x4500;
    } > dram

    .dram_mp3 __dram_vma (NOLOAD) : {
        . = 0x1000;
        *(.mp3_decram_buf)
        . = 0x4500;
    } > dram

    .dram_aac __dram_vma (NOLOAD) : {
        *(.aac_decram_buf)
        *(.aac_cache*)
        . = 0x4500;
    } > dram

    .dram_ape __dram_vma (NOLOAD) : {
        *(.apebuf.cb)
        *(.apebuf.filter)
        *(.apebuf.decode)
        *(.apebuf.seektbl)
        . = 0x3000;
    } > dram

    .dram_wma __dram_vma (NOLOAD) : {
        *(.wmabuf*)
        . = 0x3000;
    } > dram

    .dram_flac __dram_vma (NOLOAD) : {
        *(.flacbuf*)
        . = 0x3000;
    } > dram

    .dram_wav __dram_vma (NOLOAD) : {
        *(.wavbuf.dec)
        . = 0x3000;
    } > dram

    .dram_sbc __dram_vma (NOLOAD) : {
        *(.sbc_decram_buf)
        . = 0xe00;
        *(.sbcbuf*)

        *(.tsco_cache)
        *(.sco_cache)
        *(.sco_data)
        *(.sco_hci)
        *(.plc_buf)
        *(.plc_data)
        *(.sbcenc.buf)
        *(.nr_buf*)
        *(.sco_dump*)
        . = 0x4500;
    }  > dram

    .dram_lhdc __dram_vma (NOLOAD) : {
        *(.lhdc_buf*)
        . = 0x4500;
    } > dram

    .dram_rec __dram_vma (NOLOAD) : {
        *(.karaok.rec)
        . = 0xD38;
    } > dram

    .dram_usb __dram_vma (NOLOAD) : {
        *(.usb.device.desc.buf)
        *(.ude.aubuf)
        . = 0x3000;
    } > dram

    .dram_spf __dram_vma (NOLOAD) : {
        *(.spf_buf*)
        . = 0x3000;
    } > dram

    .dram_i2s __dram_vma (NOLOAD) : {
        *(.iis_dmabuf)
        . = 0x3000;
    } > dram

    .dram_opus __dram_vma (NOLOAD) : {
        *(.opus_buf*)
        //. = 0x4500;
    } > dram

    .dram_eq_rec __dram_vma (NOLOAD) : {
        *(.eq_rec_buf)
        . = 0x1000;
    }  > dram

    .dram_src __dram_vma (NOLOAD) : {
        . = 0x3000;
        *(.src_buf)
    }  > dram

    .nrram_peri_nr __nrram_vma (NOLOAD) : {
        *(.peri_nr*)
        . = 0x2000;
    } > nrram

    .nrram_wsbc __nrram_vma (NOLOAD) : {
        *(.wsbc_buf*)
        . = 0x2000;
    } > nrram

    .eram_mp3enc __eram_vma (NOLOAD) : {
        *(.mp3_enc_hwbuf)
        . = 0xa00;
    } > eram

    .eram_mp2enc __eram_vma (NOLOAD) : {
        *(.l2enc_buf.cb)
        . = 0xa00;
    } > eram

    .eram_fot __eram_vma (NOLOAD) : {
        *(.fot_data.buf)
        . = 0xa00;
    } > eram

    .eram_qtest __eram_vma (NOLOAD) : {
        *(.qtest_buf)
        . = 0xa00;
    } > eram

    .nram_npu __nram_vma (NOLOAD) : {
        *(.npu_weight)
        *(.npu_ram0)
        *(.npu_ram1)
        . = 0x19000;
    } > nram

    .nram_npu_asr __nram_vma (NOLOAD) : {
        *(.npu_matrix.weight*)
        *(.ws_asr.offset)
        *(.ws_asr.buf)
        *(.ws_asr.feat)
        *(.ws_asr.data)
        *(.npu_matrix.ram1*)
        *(.ws_asr.ram0.sum.s)
        *(.ws_asr.test)
        *(.vad.mic_buf*)
        *(.vad.dump*)
        . = 0x10000;
        *(.npu_matrix.ram0.x)
        *(.ws_asr.ram0*)
        *(.vad*)
        *(.ws_asr.sum*)
        . = 0x14000;
        *(.npu_matrix.ram0.tdnn)
        *(.npu_matrix.code*)
        . = 0x19000;
    } > nram

    .lhdcv5_ram __code_end_lhdcv5_text (NOLOAD) : {
        *(.lhdc_lib_buf.lhdcv5*)
    } > lhdc_ram

    .lhdcv4_ram __code_end_lhdcv4_text (NOLOAD) : {
        *(.lhdc_lib_buf.lhdcv3*)
        *(.lhdc_lib_buf.lhdcv4*)
    } > lhdc_ram

    .lhdc_com_ram __lhdc_ram_vma (NOLOAD) : {
        . = __lhdc_ram_size - __lhdc_com_ram_size;
        *(.lhdc_lib_buf*)
    } > lhdc_ram

    .nram_ldac __nram_vma (NOLOAD) : {
        *(.ldac_buf*)
        . = 0x11000;
    } > nram

    .nram_a2dp __nram_vma (NOLOAD) : {
        . = 0x11000;
        *(.a2dp_excache)                //LHDC和LDAC都要使用
    } > nram

    .nram_wma __nram_vma (NOLOAD) : {
        *(*wma_coefs_buf0)
        *(.wma_coefs_buf)
        *(.wma_ctx_buf)
        *(.wma_wincb_buf)
        *(.wma_id3_buf)
        *(.wmabuf*)
    } > nram

    .nram_flac __nram_vma (NOLOAD) : {
        *(.flac_decoded_buf)
    } > nram

    .nram_audio __nram_audio_vma (NOLOAD) : {
        *(.music_exbuff*)
    } > nram_audio

    .anc_alg __anc_alg_vma (NOLOAD) : {
        __anc_alg_start = .;
        *(.anc_data*)
        *(.sndp_sae_buf*)
        __anc_alg_end = .;
    } > anc_alg
    __anc_alg_size = __anc_alg_end - __anc_alg_start;

    .nram_ttp __nram_ttp_vma (NOLOAD) : {
        __nram_ttp_start = .;
        *(.ttp_data*)
        __nram_ttp_end = .;
        . = 0x1000;
    } > nram_ttp
    __nram_ttp_size = __nram_ttp_end - __nram_ttp_start;

    .anc_tool_data (NOLOAD) : {
        *(.anc_tool_buf*)
    } > anc_tool_ram
}

//Calc the lma
__bss_size = __bss_end - __bss_start;
__bank_size = SIZEOF(.flash);
__comm_lma = LOADADDR(.comm);
__comm_size = SIZEOF(.comm);
__cram_dnn_comm_lma = LOADADDR(.cram_dnn_comm);
__cram_dnn_comm_size = SIZEOF(.cram_dnn_comm);
__cram_dnn_pro_comm_lma = LOADADDR(.cram_dnn_pro_comm);
__cram_dnn_pro_comm_size = SIZEOF(.cram_dnn_pro_comm);
__cram_aiaec_dnn_comm_lma = LOADADDR(.cram_aiaec_dnn_comm);
__cram_aiaec_dnn_comm_size = SIZEOF(.cram_aiaec_dnn_comm);
__cram_ldac_comm_lma = LOADADDR(.cram_ldac_comm);
__cram_ldac_comm_size = SIZEOF(.cram_ldac_comm);
__lhdc_comm_vma = __code_start_lhdc_com_text;
__lhdc_comm_lma = LOADADDR(.lhdc_com_text);
__lhdc_comm_size = SIZEOF(.lhdc_com_text);
__lhdcv5_text_vma = __code_end_lhdc_com_text;
__lhdcv5_text_lma = LOADADDR(.lhdcv5_text);
__lhdcv5_text_size = SIZEOF(.lhdcv5_text);
__lhdcv4_text_vma = __code_end_lhdc_com_text;
__lhdcv4_text_lma = LOADADDR(.lhdcv4_text);
__lhdcv4_text_size = SIZEOF(.lhdcv4_text);
__cram_sndp_comm_lma = LOADADDR(.cram_sndp_comm);
__cram_sndp_comm_size = SIZEOF(.cram_sndp_comm);
__cram_dmdnn_comm_lma = LOADADDR(.cram_dmdnn_comm);
__cram_dmdnn_comm_size = SIZEOF(.cram_dmdnn_comm);
__cram_ldmdnn_comm_lma = LOADADDR(.cram_ldmdnn_comm);
__cram_ldmdnn_comm_size = SIZEOF(.cram_ldmdnn_comm);
__cram_ains_comm_lma = LOADADDR(.cram_ains_comm);
__cram_ains_comm_size = SIZEOF(.cram_ains_comm);
__nram_audio_comm_lma = LOADADDR(.nram_audio_comm);
__nram_audio_comm_size = SIZEOF(.nram_audio_comm);
__anc_alg_comm_lma = LOADADDR(.anc_alg_comm);
__anc_alg_comm_size = SIZEOF(.anc_alg_comm);
#if !WARNING_WSBC_EN
__nrram_dec_comm_lma = LOADADDR(.nrram_dec_comm);
__nrram_dec_comm_size = SIZEOF(.nrram_dec_comm);
#endif
__anc_tool_code_vma = __anc_tool_ram_vma;
__anc_tool_code_lma = LOADADDR(.anc_tool_code);
__anc_tool_code_size = SIZEOF(.anc_tool_code);

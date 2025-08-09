#ifndef PRODUCER_H
#define PRODUCER_H

#include <systemc.h>

SC_MODULE(Producer) {
    sc_fifo_out<int> out;

    SC_CTOR(Producer) {
        SC_THREAD(produce);
    }

    void produce() {
        for (int i = 0; i < 5; ++i) {
            wait(1, SC_SEC);
            std::cout << "[Producer] Sending: " << i << std::endl;
            out.write(i);
        }
    }
};

#endif

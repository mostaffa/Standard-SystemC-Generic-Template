#ifndef CONSUMER_H
#define CONSUMER_H

#include <systemc.h>

SC_MODULE(Consumer) {
    sc_fifo_in<int> in;

    SC_CTOR(Consumer) {
        SC_THREAD(consume);
    }

    void consume() {
        while (true) {
            int value = in.read();
            std::cout << "[Consumer] Received: " << value << std::endl;
        }
    }
};

#endif

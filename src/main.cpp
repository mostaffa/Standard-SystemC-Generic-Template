#include <systemc.h>
#include "Producer.h"
#include "Consumer.h"

int sc_main(int argc, char* argv[]) {
    sc_fifo<int> fifo(10);

    Producer producer("Producer");
    Consumer consumer("Consumer");

    producer.out(fifo);
    consumer.in(fifo);

    sc_start(10, SC_SEC);
    return 0;
}

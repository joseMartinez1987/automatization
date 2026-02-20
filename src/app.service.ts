import { Injectable } from '@nestjs/common';
import PQueue from 'p-queue';

@Injectable()
export class AppService {
  private readonly queue = new PQueue({ concurrency: 5 });

  async getHello() {
    const tasks = Array.from({ length: 20 }, (_, i) => i + 1);
    const promiseFns = tasks.map((taskId) => () => this.promiseFn(taskId));
    console.time('Processing 20 tasks with concurrency 5');
    console.log('Starting to process 20 tasks with concurrency limit of 5');
    await this.queue.addAll(promiseFns);
    console.timeEnd('Processing 20 tasks with concurrency 5');
    console.log('All tasks completed!');
  }

  async promiseFn(taskId: number) {
    console.log(
      `🚀 Task ${taskId} started executing (concurrency slot acquired)`,
    );
    return new Promise((resolve) => {
      setTimeout(() => {
        console.log(`✅ Task ${taskId} completed`);
        resolve('Done');
      }, 6000);
    });
  }
}

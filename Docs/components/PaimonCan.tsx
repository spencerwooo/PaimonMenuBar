import Image from 'next/image'

import hehe from '../images/paimon/hehe.png'
import shipOut from '../images/paimon/ship_out.png'
import timeToEat from '../images/paimon/time_to_eat.png'
import tooEasy from '../images/paimon/too_easy.png'

const PaimonCan = () => {
  return (
    <div className="bg-white/5 w-full p-4">
      <div className="max-w-2xl mx-auto">
        <h2 className="text-xl font-black mb-4">paimon can ...</h2>
        <p className="flex items-center">
          <span className="mr-1">keep track of your daily resin</span>
          <Image src={hehe} alt="paimon-hehe" width={40} height={40} />
        </p>
        <p className="flex items-center">
          <span className="mr-1">see when your expeditions are complete</span>
          <Image src={shipOut} alt="paimon-hehe" width={40} height={40} />
        </p>
        <p className="flex items-center">
          <span className="mr-1">
            check for your realm currency to avoid overflow
          </span>
          <Image src={timeToEat} alt="paimon-hehe" width={40} height={40} />
        </p>
        <p className="flex items-center">
          <span className="mr-1">
            so you can reuse your parametric transformer just in time
          </span>
          <Image src={tooEasy} alt="paimon-hehe" width={40} height={40} />
        </p>
      </div>
    </div>
  )
}

export default PaimonCan

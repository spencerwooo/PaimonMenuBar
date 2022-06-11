import Image from 'next/image'
import Atropos from 'atropos/react'
import screenshot from '../images/screenshot-transparent-light.png'

const Screenshot3D = () => {
  return (
    <Atropos className="w-[300px] h-[494px]" duration={150}>
      <Image
        src={screenshot}
        alt="PaimonMenuBar screenshot"
        width={300}
        height={494}
      />
    </Atropos>
  )
}
export default Screenshot3D

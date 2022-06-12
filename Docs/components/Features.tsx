import Image, { StaticImageData } from 'next/image'

import daily from '../images/daily.png'
import expedition from '../images/expedition.png'
import fragileResin from '../images/fragile-resin.png'
import weeklyBoss from '../images/weekly-boss.png'
import jarOfRiches from '../images/jar-of-riches.png'
import parametric from '../images/parametric-transformer.png'

const IconCard = ({
  icon,
  label,
  style,
}: {
  icon: StaticImageData
  label: string
  style: string
}) => (
  <div
    className={`rounded-lg lg:text-lg flex flex-col items-center justify-center py-6 ${style}`}
  >
    <Image src={icon} alt="icon" width={36} height={36} />
    <span className="mt-2">{label}</span>
  </div>
)

const Features = () => (
  <div className="relative grid grid-cols-2 md:grid-cols-3 2xl:grid-cols-6 gap-4 md:gap-8 mt-12 py-16 px-4 md:px-8 border-y border-white/20 bg-[#232c33]">
    <IconCard
      icon={fragileResin}
      label="Resin"
      style="bg-blue-900/30 text-blue-200"
    />
    <IconCard
      icon={daily}
      label="Daily Commissions"
      style="bg-purple-900/30 text-purple-200"
    />
    <IconCard
      icon={expedition}
      label="Expeditions"
      style="bg-orange-900/30 text-orange-200"
    />
    <IconCard
      icon={weeklyBoss}
      label="Weekly Bosses"
      style="bg-yellow-900/30 text-amber-200"
    />
    <IconCard
      icon={jarOfRiches}
      label="Realm Currency"
      style="bg-gray-900/30 text-gray-200"
    />
    <IconCard
      icon={parametric}
      label="Parametric Transformer"
      style="bg-teal-900/30 text-teal-200"
    />
  </div>
)

export default Features

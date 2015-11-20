using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScriptEngine.Machine.Contexts
{
    public abstract class TypeQualifierContextBase : PropertyNameIndexAccessor
    {
        protected bool EqualsImpl<T>(IValue other, Func<T, bool> comparer) where T:class
        {
            var qualifier = other.GetRawValue() as T;
            if (qualifier == null)
                return false;

            return comparer(qualifier);

        }
    }

    public sealed class StringQualifier : TypeQualifierContextBase
    {
        public StringQualifier(int len, AvailableLengthType lenType = StringQualifier.AvailableLengthType.Variable) : base()
        {
            Lenght = len;
            AvailableLength = lenType;    
        }

        public override bool Equals(IValue qualifier)
        {
            return EqualsImpl<StringQualifier>(qualifier, (o)=>Lenght == o.Lenght && AvailableLength == o.AvailableLength);
        }
        
        public int Lenght { get; private set; }
        public AvailableLengthType AvailableLength { get; private set;}

        public enum AvailableLengthType
        {
            Variable,
            Fixed
        }

    }

    public sealed class NumberQualifier : TypeQualifierContextBase
    {

        public NumberQualifier(int IntegerPart, int Fraction = 0, bool NonNeg = false)
            : base()
        {
            IntegerDigits = IntegerPart;
            FractionDigits = Fraction;
            NonNegative = NonNeg;
        }

        public override bool Equals(IValue other)
        {
            return EqualsImpl<NumberQualifier>(other, (o) => IntegerDigits == o.IntegerDigits && FractionDigits == o.FractionDigits && NonNegative == o.NonNegative);
        }

        public int IntegerDigits { get; private set; }
        public int FractionDigits { get; private set; }
        public bool NonNegative { get; private set; }

    }

    public sealed class DateQualifier : TypeQualifierContextBase
    {

        public DateQualifier(DateFractionsType dateFractions) : base()
        {
            DateFractions = dateFractions;
        }

        public override bool Equals(IValue other)
        {
            return EqualsImpl<DateQualifier>(other, (o) => DateFractions == o.DateFractions);
        }

        public DateFractionsType DateFractions { get; private set; }

        public enum DateFractionsType
        {
            DateAndTime,
            Date,
            Time
        }

    }

}
